class StatisticsController < ApplicationController
  
  def index
    @dimensions = Questionnaire.current.dimensions
    @scorer = OrganisationScorer.new
  end
        
end