class Dimension < ActiveRecord::Base
    has_many :activities
    belongs_to :questionnaire

    validates :title, presence: true          
    validates :name, presence: true
    validates :name, uniqueness: {scope: :questionnaire_id, message: "dimension name should be unique within questionnaire" }
  
end
