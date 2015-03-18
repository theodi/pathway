class Questionnaire < ActiveRecord::Base
   has_many :dimensions
   has_many :activities
   
   validates :version, presence: true
   
   #which is the current questionnaire that users should be answering?
   #TODO: improve this to make it easier to switch which questionaire is "live"
   def self.current
     return Questionnaire.order("version desc").first
   end
   
end
