class AssessmentsController < ApplicationController
  def index
    @assessments = current_user.assessments.order(:completion_date)
  end

  def destroy
    @assessment = current_user.assessments.find(params[:id])
    @assessment.destroy
    redirect_to assessments_path
  end
end
