class AssessmentAnswersController < ApplicationController

  def new
    @assessment = current_user.assessments.find(params[:assessment_id])
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    @dimension = @activity.dimension

    authorize! :update, @assessment
    @assessment_answer = @assessment.assessment_answers.build(question: @question)
  end

  def create
    @assessment = current_user.assessments.find(params[:assessment_id])
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    @dimension = @activity.dimension
    
    authorize! :update, @assessment
    @assessment_answer = @assessment.assessment_answers.build(assessment_answer_params)
    if @assessment_answer.save
      redirect_to assessment_path(@assessment)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  private

  def assessment_answer_params
    params.merge(assessment_answer: { question_id: params[:question_id] }) if params[:question_id]
    params.require(:assessment_answer).permit(:question_id, :answer_id, :notes)
  end

end
