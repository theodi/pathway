class StatisticsGenerator
  
  def generate_stats_for_all_organisations
    group = Organisation.all_organisations_group
    raise "Unable to find 'All Organisations' group" unless group.present?
    scorer = OrganisationScorer.new
    generate(group, scorer.score_all_organisations)
  end

  def generate_stats_for_all_countries_with_users_with_organisations
    scorer = OrganisationScorer.new
    Country.all.each do |country|
      generate( country, scorer.score_country(country) ) if country.users_with_organisations.count > 0
    end
  end

  def generate_stats_for_dgu_organisations
    group = Organisation.all_dgu_organisations_group
    raise "Unable to find 'All data.gov.uk organisations' group" unless group.present?
    scorer = OrganisationScorer.new
    generate(group, scorer.score_dgu_organisations)    
  end  
  
  def generate_stats_for_dgu_groups
    scorer = OrganisationScorer.new
    Organisation.all.each do |group|
      generate( group, scorer.score_children(group) ) if group.parent?
    end
  end
  
  #organisation: group whose stats are being stored 
  #scores: the stats for that group
  def generate(group, scores)
    scores[:activities].each do |activity_name, counts|
      activity = Activity.find_by_name(activity_name)
      raise "Unable to find activity" unless activity.present?
      
      stats = OrganisationScore.find_or_create_by( organisation: group, activity: activity )
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
  end
  
end