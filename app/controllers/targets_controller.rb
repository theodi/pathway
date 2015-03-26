class TargetsController < ApplicationController

  def edit
    @score = Score.find(params[:score_id])
    @assessment = @score.assessment
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions
  end


  def update
    @score = Score.find(params[:score_id])
    @assessment = @score.assessment
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions
  end

end
