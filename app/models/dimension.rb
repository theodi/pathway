class Dimension < ActiveRecord::Base
    has_many :activities
    belongs_to :questionnaire

    validates :title, presence: true          
    validates :name, presence: true
    validates :name, uniqueness: {scope: :questionnaire_id, message: "dimension name should be unique within questionnaire" }
  
  def questions
    Question.joins(:activity).where(activities: { dimension_id: self.id })
  end
end
