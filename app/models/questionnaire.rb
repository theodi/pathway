class Questionnaire < ActiveRecord::Base
   has_many :dimensions
   has_many :activities
   
   validates :version, presence: true
end
