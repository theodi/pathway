class AssessmentAnswer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :question
  belongs_to :answer
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :links, :reject_if => lambda { |a| a["link"].blank? }, allow_destroy: true

  validates :question_id, presence: true
  validates :answer_id, presence: true
  validates :assessment_id, presence: true
  validates :question_id, uniqueness: { scope: :assessment_id, message: " has already beeen answered for this quesion." }

  def prev
    previous_question = question.prev
    if previous_question
      assessment.assessment_answers.where(question_id: previous_question).first
    else
      nil
    end
  end

  def next
    next_question = question.next
    if next_question
      assessment.assessment_answers.where(question_id: next_question).first
    else
      nil
    end
  end
end
