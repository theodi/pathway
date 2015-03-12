class AssessmentsController < ApplicationController
  def index
    @current_assessment = current_user.current_assessment
    @assessments = current_user.assessments.completed.order(:completion_date)
  end

  def new
    @assessment = current_user.assessments.build
  end

  def create
    @assessment = current_user.assessments.build(params[:assessment])
    if @assessment.save
      redirect_to assessments_path
    else
      render 'new'
    end
  end

  def show
    @assessment = Assessment.find(params[:id])
    @dimensions = Dimension.all
  end

  def destroy
    @assessment = current_user.assessments.find(params[:id])
    @assessment.destroy
    redirect_to assessments_path
  end
end
