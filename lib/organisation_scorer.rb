class OrganisationScorer
  
  def score_all_organisations
    set = User.all
    score_organisations( set )
  end
  
  def score_dgu_organisations
    set = Organisation.joins(:users).where("dgu_id is not null")
    score_organisations( set )
  end

  def score_children(organisation)
    set = Organisation.joins(:users).where("dgu_id is not null and parent = ?", organisation.id)
    score_organisations( set )
  end  
  
  def score_country(country)
    set = country.users_with_organisations
    score_organisations( set )
  end  
  
  def score_organisations(organisations)
    results = {
      activities: {},
      organisations: organisations.size,
      completed: 0  
    }    
    if organisations.respond_to? :organisational_users
      results[:registered_users] = organisations.organisational_users.count
    end
    Questionnaire.current.activities.each do |activity|
      results[:activities][activity.name] = [0,0,0,0,0]
    end
    organisations.each do |organisation|
      assessment = organisation.latest_completed_assessment
      if assessment.present?
        results[:completed] += 1
        assessment.scores.each do |score|
          results[:activities][score.activity.name][score.score - 1 ] += 1
        end
      end
    end
    return results
  end  

  def normalise_counts(results, bins=5)
    bin_size = results[:completed].to_f / bins.to_f
    normalised = {
      activities: {},
      organisations: results[:organisations],
      completed: results[:completed]
    }
    results[:activities].each do |name, counts|
      normalised[:activities][name] = counts.map { |c| c == 0 ? 0 : (c.to_f / bin_size).ceil}
    end
    normalised
  end
  
  def read_all_organisations
    read_scores_from_statistics( Organisation.all_organisations_group, User.count )
  end
  
  def read_country_organisations(country)
    read_scores_from_statistics( country, country.users_with_organisations.count )
  end
  
  def read_dgu_organisations
    read_scores_from_statistics( Organisation.all_dgu_organisations_group, Organisation.joins(:users).where("dgu_id is not null").count )
  end
  
  def read_group(organisation)
    read_scores_from_statistics( organisation, Organisation.where("parent = ?", organisation.id).count )
  end
    
  def read_scores_from_statistics(group, count)
    results = {
      activities: {},
      organisations: count,
      completed: 0  
    }    
    Questionnaire.current.activities.each do |activity|
      results[:activities][activity.name] = [0,0,0,0,0]
    end
    results[:completed] = group.statistics.first ? group.statistics.first.completed_assessments : 0
    group.statistics.each do |organisation_score|
      results[:activities][organisation_score.activity.name] = 
          [organisation_score.initial, 
           organisation_score.repeatable, 
           organisation_score.defined,
           organisation_score.managed,
           organisation_score.optimising]
    end
    results
  end
  
    
end