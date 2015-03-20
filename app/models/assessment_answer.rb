class AssessmentAnswer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :question
  belongs_to :answer
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true

  validates :question_id, presence: true
  validates :answer_id, presence: true
  validates :assessment_id, presence: true
  validates :question_id, uniqueness: { scope: :assessment_id, message: " has already beeen answered for this quesion." }
end
