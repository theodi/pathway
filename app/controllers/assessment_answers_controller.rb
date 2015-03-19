class AssessmentAnswersController < ApplicationController

  before_filter :load_and_authorize_assessment

  def new
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    @dimension = @activity.dimension
    @assessment_answer = @assessment.assessment_answers.build(question: @question)
  end

  def create
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    @dimension = @activity.dimension
    
    existing_answer = @assessment.assessment_answers.where(question_id: @question.id).first
    existing_answer.destroy unless existing_answer.blank?

    @assessment_answer = @assessment.assessment_answers.build(assessment_answer_params)
    
    if @assessment_answer.save
      next_question = @activity.next_question_for(@assessment)
      redirection = next_question.blank? ? assessment_path(@assessment) : assessment_question_path(@assessment, next_question)
      redirect_to redirection
    else
      render 'new'
    end
  end

  def edit
    @assessment_answer = @assessment.assessment_answers.find(params[:id])
    @question = @assessment_answer.question
    @activity = @question.activity
    @dimension = @activity.dimension
  end

  def update
    @assessment_answer = @assessment.assessment_answers.find(params[:id])
    @question = @assessment_answer.question
    @activity = @question.activity
    @dimension = @activity.dimension
    if @assessment_answer.update_attributes(assessment_answer_params)
      next_question = @activity.next_question_for(@assessment)
      redirection = next_question.blank? ? assessment_path(@assessment) : assessment_question_path(@assessment, next_question)
      redirect_to redirection
    else
      render 'edit'
    end
  end

  private

  def assessment_answer_params
    params[:assessment_answer].merge!( { question_id: params[:question_id] } ) if params[:question_id]
    params.require(:assessment_answer).permit(:question_id, :answer_id, :notes, links_attributes: [:text, :link, :_destroy, :id])
  end

  def load_and_authorize_assessment
    @assessment = current_user.assessments.find(params[:assessment_id])
    authorize! :update, @assessment
  end

end