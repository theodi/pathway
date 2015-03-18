class Assessment < ActiveRecord::Base
  belongs_to :user
  has_many :assessment_answers, dependent: :destroy
  has_many :scores, dependent: :destroy

  def self.completed
    where.not(completion_date: nil)
  end

  def status
    if start_date.blank?
      :not_started
    elsif completion_date.blank?
      :incomplete
    else
      :complete
    end 
  end

  def can_complete?
    return ProgressCalculator.new(self).can_mark_completed?
  end
  
  def complete
    return false unless ProgressCalculator.new(self).can_mark_completed?
    self.completion_date = DateTime.now
    
    scorer = AssessmentScorer.new(self)
    Questionnaire.current.activities.each do |activity|
      self.scores.build(activity: activity, score: scorer.score_activity(activity)) if activity.questions.length > 0
    end
    
    save
  end
    
end