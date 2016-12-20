class StatisticsGenerator
   
  def initialize
    @scorer = OrganisationScorer.new
    @dimensions = Questionnaire.current.dimensions
    @organisationScoreFinder = -> (group, activity) {
      OrganisationScore.find_or_create_by( organisation: group, activity: activity ) 
    }
    @countryScoreFinder = -> (group, activity) {
      CountryScore.find_or_create_by( country: group, activity: activity )
    }
  end
   
  def init_public_scores
    {
        completed: 0,
        organisations: 0,
        themes: {}
    }
  end
  
  def init_public_score_dimensions(data)
    @dimensions.each do |dimension|
      data[:themes][dimension.title] = {}
      dimension.activities.each do |activity|
        data[:themes][dimension.title][activity.title] = [0,0,0,0,0]
      end
    end 
    return data
  end
  
  def create_public_scores(data, scores)
    data[:completed] = scores[:completed]
    data[:organisations] = scores[:organisations]
    @dimensions.each do |dimension|
      data[:themes][dimension.title] = {}
      dimension.activities.each do |activity|
        data[:themes][dimension.title][activity.title] = scores[:activities][activity.name]
      end
    end
    return data
  end
  
  def generate_stats_for_all_countries
    ## ensure no stale data for particular country remains
    CountryScoresDatum.delete_all
    all_other_countries_scores = init_public_score_dimensions(init_public_scores)
    not_specified_scores = init_public_score_dimensions(init_public_scores)
    Country.all.each do |country|
      generate_stats_for_all_countries_with_users_with_organisations(country)
      generate_country_scores(country, all_other_countries_scores)
    end
    updateCountryScoresData("All other countries", all_other_countries_scores)
    User.organisational_users.with_no_country.each do |user|
      sum_not_specified_scores(user, not_specified_scores)
    end
    updateCountryScoresData("Not specified", not_specified_scores)
  end

  def generate_stats_for_all_countries_with_users_with_organisations(country)
    country_score = @scorer.score_country(country)
    generate(@countryScoreFinder.curry[country], country_score) if country.users_with_organisations.count > 0
  end
  
  def generate_country_scores(country, all_other_countries_scores)
    scores = @scorer.read_country_organisations(country)
    if scores[:completed] >= ODMAT::Application::HEATMAP_THRESHOLD
      country_data = create_public_scores(init_public_scores, scores)
      updateCountryScoresData(country.name, country_data)
    else
      sum_scores(all_other_countries_scores, scores)
    end
  end
  
  def sum_not_specified_scores(user, not_specified_scores) 
    scores = @scorer.read_group(user.associated_organisation)
    sum_scores(not_specified_scores, scores)
  end
  
  def sum_scores(total_scores, next_scores)
    total_scores[:completed] += next_scores[:completed]
    total_scores[:organisations] += next_scores[:organisations]
    @dimensions.each do |dimension|
      dimension.activities.each do |activity|
        score = next_scores[:activities][activity.name]
        total_scores[:themes][dimension.title][activity.title] = [total_scores[:themes][dimension.title][activity.title], score].transpose.map do |x|
          x.reduce(:+)
        end
      end
    end
  end
  
  def updateCountryScoresData(name, data)
    json = JSON.generate({:country => name}.merge!(data))
    record = CountryScoresDatum.find_or_initialize_by(name: name)
    record.update_attributes!(data: json)
  end
     
  def generate_stats_for_all_organisations
    group = Organisation.all_organisations_group
    raise "Unable to find 'All Organisations' group" unless group.present?
    generate(@organisationScoreFinder.curry[group], @scorer.score_all_organisations)
  end

  def generate_stats_for_dgu_organisations
    group = Organisation.all_dgu_organisations_group
    raise "Unable to find 'All data.gov.uk organisations' group" unless group.present?
    generate(@organisationScoreFinder.curry[group], @scorer.score_dgu_organisations)    
  end  
  
  def generate_stats_for_dgu_groups
    Organisation.all.each do |group|
      generate(@organisationScoreFinder.curry[group], @scorer.score_children(group) ) if group.parent?
    end
  end
  
  #organisation: group whose stats are being stored 
  #scores: the stats for that group
  def generate(scoreFinder, scores)
    scores[:activities].each do |activity_name, counts|
      activity = Activity.find_by_name(activity_name)
      raise "Unable to find activity" unless activity.present?
      stats = scoreFinder.call(activity)
      stats[:initial] = counts[0]
      stats[:repeatable] = counts[1]
      stats[:defined] = counts[2]
      stats[:managed] = counts[3]
      stats[:optimising] = counts[4]
      stats.save
    end
  end
  
  def generate_all
    generate_stats_for_all_organisations
    generate_stats_for_dgu_organisations
    generate_stats_for_dgu_groups
    generate_stats_for_all_countries
  end
  
end