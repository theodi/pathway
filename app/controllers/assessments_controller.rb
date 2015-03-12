class AssessmentsController < ApplicationController
  def index
    @current_assessment = current_user.current_assessment
    @assessments = current_user.assessments.completed.order(:completion_date)
  end

  def destroy
    @assessment = current_user.assessments.find(params[:id])
    @assessment.destroy
    redirect_to assessments_path
  end
end
