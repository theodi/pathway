class TargetsController < ApplicationController

  def edit
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions
  end

  def update
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions

    if @score.update_attributes(params[:score])
      redirect_to assessments_path, notice: "Successfully saved goals"
    else
      render 'edit'
    end
  end

  private

  def target_params
    params.require(:targets).permit(:activity_id, :value)
  end

end
