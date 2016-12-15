class Assessment < ActiveRecord::Base
  belongs_to :user
  has_many :assessment_answers, dependent: :destroy
  has_many :scores, dependent: :destroy
  validates :title, presence: true

  def self.completed
    where.not(completion_date: nil)
  end

  def to_csv(style=:dimension)    
    if style == :dimension
      scores = AssessmentScorer.new(self).score_dimensions_from_saved_results()
      total_score = 0
      maximum = 0
      data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
        csv << ["Theme", "Score", "Maximum"]
        Questionnaire.current().dimensions.each do |dimension|
          total_score += scores[dimension.name][:score]
          maximum += scores[dimension.name][:max]
          csv << [ dimension.title, scores[dimension.name][:score], scores[dimension.name][:max] ]
        end
        csv << ["Total", total_score, maximum]  
      end
    else
      data = CSV.generate({col_sep: ",", row_sep: "\r\n", quote_char: '"'}) do |csv|
        csv << ["Theme", "Activity", "Score", "Target"]
        Questionnaire.current().dimensions.each do |dimension|
          dimension.activities.each do |activity|
            scores = self.scores.where(activity_id: activity.id)
            csv << [ dimension.title, activity.title, scores.first.score, scores.first.target ] if scores.present?
          end
        end
      end      
    end
    return data
  end
  
  def foo
    "bar"
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
    generate_share_token
    
    scorer = AssessmentScorer.new(self)
    Questionnaire.current.activities.each do |activity|
      self.scores.build(activity: activity, score: scorer.score_activity(activity)) if activity.questions.length > 0
    end
    
    save
  end

  def next_activity
    progress = ProgressCalculator.new(self)
    Questionnaire.current.activities.each do |activity|
      #Rails.logger.info("\n #{activity.title} - #{progress.progress_for_activity(activity)}")
      return activity if [:not_started, :in_progress].include? progress.progress_for_activity(activity)
    end
    nil
  end
  
  def answer_for_question(question)
    return AssessmentAnswer.where(assessment_id: self.id, question_id: question.id).first
  end

  def update_targets(score_targets)
    begin
      scores = []
      Score.transaction do
        score_targets.each do |score_id, target|
          score = self.scores.find(score_id)
          score.update_attributes!(target: target)
          scores << score
        end
      end
      scores
    rescue ActiveRecord::RecordInvalid => invalid
      nil
    end    
  end
  
  def generate_share_token
    self.token = loop do
      random_code = SecureRandom.urlsafe_base64(nil, false)
      break random_code unless self.class.exists?(token: random_code)
    end
  end

  def self.users_with_no_country
    return Assessment.joins(:user).where("users.country_id is null")
  end

end
