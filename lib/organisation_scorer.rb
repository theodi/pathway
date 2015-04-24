class OrganisationScorer
  
  def score_all_organisations
    score_organisations( Organisation.all )
  end
  
  def score_dgu_organisations
    score_organisations( Organisation.where("dgu_id is not null") )
  end

  def score_children(organisation)
    score_organisations( Organisation.where("parent = ?", organisation.id) )
  end  
  
  def score_organisations(organisations)
    results = {
      activities: {},
      children: organisations.size,
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
    bin_size = results[:completed] / bins
    normalised = {}
    results[:activities].each do |name, counts|
    normalised[name] = counts.map { |c| c == 0 ? 0 : (c.to_f / bin_size).ceil}
    end
    results[:activities] = normalised
    results
  end
  
  
end