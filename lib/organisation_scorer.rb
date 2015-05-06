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
  
  def score_organisations(organisations)
    results = {
      activities: {},
      organisations: organisations.size,
      completed: 0  
    }    
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
  
  
end