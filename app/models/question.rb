class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :activity
  belongs_to :questionnaire

  has_many :dependents, class_name: "Question",
                           foreign_key: "dependency_id"   
  belongs_to :dependency, class_name: "Question"  
  
  validates :text, presence: true    
  validates :code, presence: true      
  validates :code, uniqueness: {scope: :questionnaire_id, message: "question code should be unique within questionnaire" }

end