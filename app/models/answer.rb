class Answer < ActiveRecord::Base
  belongs_to :question
  
  validates :text, presence: true    
  validates :code, presence: true      
  validates :code, uniqueness: {scope: :questionnaire_id, message: "answer code should be unique within questionnaire" }
  validates :score, :presence => true, if:  Proc.new { |a| !a.positive? }
  validates :score, :inclusion => {:in => [1,5], allow_blank: true, message: "maturity scores must be between 1-5"}
end
