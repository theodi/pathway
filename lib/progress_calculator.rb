class ProgressCalculator
  
  attr_reader :assessment
  
  def initialize(assessment)
    @assessment = assessment
  end
  
  #is the assessment complete?
  def completed?
    @assessment.status == :complete
  end
    
  def activity_completed?(activity)
    return progress_for_activity(activity) == :complete
  end
  
  #progress for a single activity
  def progress_for_activity(activity)
    #if there are no questions, then skipped
    return :skipped if activity.questions.empty?
    
    #find the assesssment_answers for all questions that are associated with this activity
    assessment_answers = AssessmentAnswer.joins(:assessment, question: :activity).where(assessment: @assessment.id, questions: {activity_id: activity.id})

    #if there are non, then not started
    return :not_started if assessment_answers.empty?

    #if there are same number as questions, then completed
    return :complete if assessment_answers.length == activity.questions.length
    
    #if there are any negative answers, then completed
    assessment_answers.each do |aa|
      return :complete if !aa.answer.positive?
    end
    
    #otherwise in progress
    :in_progress
  end
  
  #summary of progress for all activities
  def progress_for_all_activities
    progress = {}
    Questionnaire.current.activities.each do |activity|
      progress[ activity.name ] = progress_for_activity(activity)
    end
    progress
  end
  
  #percentage completion across the entire maturity assessment
  def percentage_progress
    progress = progress_for_all_activities.reject{ |k,v| v == :skipped }
    completed = progress.values.count {|state| state == :complete }
    return (completed.to_f / progress.values.length.to_f * 100).to_i   
  end  
  
  #can we mark the assessment as completed?
  def can_mark_completed?
    progress_for_all_activities.reject{ |k,v| v == :skipped || v == :complete }.size == 0
  end
  
end