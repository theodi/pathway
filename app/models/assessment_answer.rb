class AssessmentAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :answer
  has_many :links, dependent: :destroy
end
