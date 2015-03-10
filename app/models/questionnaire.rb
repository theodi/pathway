class Questionnaire < ActiveRecord::Base
   has_many :dimensions
   
   validates :version, presence: true
end
