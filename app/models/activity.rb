class Activity < ActiveRecord::Base
  has_many :questions
  belongs_to :dimension
  belongs_to :questionnaire
  
  validates :title, presence: true          
  validates :name, presence: true
  validates :name, uniqueness: {scope: :questionnaire_id, message: "activity name should be unique within questionnaire" }
  
  def next_question_for(assessment)
    assessment.reload
    assessment_answers = assessment.assessment_answers.where(question_id: self.questions)

    answers = Answer.where(id: assessment_answers.pluck(:answer_id))
    unanswered_questions = Question.where(activity_id: self.id).where.not(id: assessment_answers.pluck(:question_id))
    
    if unanswered_questions and answers.exists?(positive: false)
      nil #finished
    elsif unanswered_questions.blank?
      nil #finished
    else
      unanswered_questions.order(:id).first
    end   
  end

end
