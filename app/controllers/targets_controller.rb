class TargetsController < ApplicationController

  def edit
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions
    @scores = {}
    @assessment.scores.each { |s| @scores.merge!(s.activity_id => s) }
  end

  def update
    @assessment = Assessment.find(params[:assessment_id])
    authorize! :update, @assessment
    @dimensions = Questionnaire.current.dimensions
    if @assessment.update_targets(params[:targets])
      redirect_to assessments_path, notice: "Successfully saved goals"
    else
      render 'edit'
    end
  end

end
