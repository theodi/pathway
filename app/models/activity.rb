class Activity < ActiveRecord::Base
  has_many :questions
  belongs_to :dimension
  belongs_to :questionnaire
  
  validates :title, presence: true          
  validates :name, presence: true
  validates :name, uniqueness: {scope: :questionnaire_id, message: "activity name should be unique within questionnaire" }
  
end
