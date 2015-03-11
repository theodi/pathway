class Assessment < ActiveRecord::Base
  belongs_to :user
  has_many :assessment_answer, dependent: :destroy
end
