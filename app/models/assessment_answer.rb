class AssessmentAnswer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :question
  belongs_to :answer
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true
end
