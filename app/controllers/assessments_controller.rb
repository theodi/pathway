class AssessmentsController < ApplicationController
  def index
    @current_assessment = current_user.current_assessment
    @assessments = current_user.assessments.completed.order(:completion_date)
  end

  def begin
    if current_user.current_assessment.blank?
      authorize! :create, Assessment
      @assessment = current_user.assessments.create(title: "New assessment", start_date: Time.now)
      @dimensions = Questionnaire.current.dimensions
      @progress = ProgressCalculator.new(@assessment)
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
      redirect_to assessment_path(@assessment)
    else
      render 'edit'
    end
  end

  def show
    @assessment = Assessment.find(params[:id])
    authorize! :read, @assessment
    @dimensions = Questionnaire.current.dimensions
    @progress = ProgressCalculator.new(@assessment)
  end

  def destroy
    @assessment = current_user.assessments.find(params[:id])
    authorize! :destroy, @assessment
    @assessment.destroy
    redirect_to assessments_path
  end

  def complete
    @assessment = current_user.assessments.find(params[:id])
    authorize! :update, @assessment
    @assessment.complete
    redirect_to report_path(@assessment)
  end
  
  def report
    @assessment = Assessment.find(params[:id])
    @dimensions = Questionnaire.current.dimensions
    @scorer = AssessmentScorer.new(@assessment)
    authorize! :read, @assessment

    render 'report'
  end

  private
  
  def assessment_params
    params.require(:assessment).permit(:title, :notes)
  end
end
