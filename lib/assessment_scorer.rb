class AssessmentScorer
  
  def initialize(assessment)
    @assessment = assessment
    @calculator = ProgressCalculator.new(assessment)
  end
  
  def score_activity(activity)
    raise "Activity assessment not complete" unless @calculator.activity_completed?(activity)
    
    #find the assesssment_answers for all questions that are associated with this activity
    answers = AssessmentAnswer.joins(:answer, :assessment, question: :activity) \
                    .where(assessment: @assessment, questions: {activity_id: activity.id}) \
                    .order("answers.code DESC").limit(1)
    
    answers.first.answer.score
  end
  
  def score_activities(dimension = nil)
    scores = {}
    activities = dimension ? dimension.activities : Questionnaire.order("version desc").first.activities
    activities.each do |activity|
      scores[ activity.name ] = score_activity(activity) if activity.questions.length > 0
    end
    scores
  end
  
  def score_dimension(dimension)
    activities = score_activities(dimension)
    return {
      score: activities.values.inject(:+),
      max: activities.keys.size * 5
    }
  end

  def score_dimensions
    scores = {}
    Questionnaire.current.dimensions.each do |dimension|
      scores[ dimension.name]  = score_dimension(dimension)
    end
    scores
  end  
  
  def score_dimensions_from_saved_results
    scores = {}
    Questionnaire.current.dimensions.each do |dimension|
      scores[ dimension.name ] = { score: 0, max: 0 }
      dimension.activities.each do |activity|
        scores[ dimension.name ][:max] += 5 if activity.questions.length > 0
        saved_score = Score.where( assessment: @assessment, activity: activity).first
        scores[ dimension.name ][:score] += saved_score.score if saved_score
      end
    end      
    scores
  end
  
end