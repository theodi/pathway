class AssessmentsController < ApplicationController
  def index
    @current_assessment = current_user.current_assessment
    @assessments = current_user.assessments.completed.order(:completion_date)
  end

  def begin
    if current_user.current_assessment.blank?
      authorize! :create, Assessment
      @assessment = current_user.assessments.create(title: "New assessment")
      @dimensions = Dimension.all
      render 'show'
    else
      redirect_to assessment_path(current_user.current_assessment)
    end
  end

  def edit
    @assessment = current_user.assessments.find(params[:id])
    authorize! :update, @assessment
  end

  def update
    @assessment = current_user.assessments.find(params[:id])
    authorize! :update, @assessment
    if @assessment.update_attributes(assessment_params)
      @assessment.update_attribute(:start_date, Time.now)
      redirect_to assessment_path(@assessment)
    else
      render 'edit'
    end
  end

  def show
    @assessment = Assessment.find(params[:id])
    authorize! :read, @assessment
    @dimensions = Dimension.all
  end

  def destroy
    @assessment = current_user.assessments.find(params[:id])
    authorize! :destroy, @assessment
    @assessment.destroy
    redirect_to assessments_path
  end

  private
  
  def assessment_params
    params.require(:assessment).permit(:title, :notes)
  end
end
