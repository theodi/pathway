class AssessmentAnswersController < ApplicationController

  before_filter :load_and_authorize_assessment

  def continue
    activity = @assessment.next_activity
    if activity
      question = activity.next_question_for(@assessment)
      redirect_to assessment_question_path(@assessment, question)
    else
      redirect_to assessment_path(@assessment)
    end
  end

  def new
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    @dimension = @activity.dimension
    @assessment_answer = @assessment.assessment_answers.build(question: @question)
    @assessment_answer.links.build
    @previous_answer = @assessment_answer.prev
  end

  def create
    @question = Question.find(params[:question_id])
    @activity = @question.activity
    existing_answer = @assessment.assessment_answers.where(question_id: @question.id).first
    existing_answer.destroy unless existing_answer.blank?
    @assessment_answer = @assessment.assessment_answers.build(assessment_answer_params)
    
    if @assessment_answer.save
      if params[:commit].eql?("Save and exit")
        redirection = assessment_path(@assessment)
      else
        next_question = @activity.next_question_for(@assessment)
        redirection = next_question.blank? ? assessment_path(@assessment) : assessment_question_path(@assessment, next_question)
      end
      redirect_to redirection
    else
      @dimension = @activity.dimension
      @previous_answer = @assessment_answer.prev
      render 'new'
    end
  end

  def edit
    @assessment_answer = @assessment.assessment_answers.find(params[:id])
    @question = @assessment_answer.question
    @activity = @question.activity
    @dimension = @activity.dimension
    @previous_answer = @assessment_answer.prev
  end

  def update
    @assessment_answer = @assessment.assessment_answers.find(params[:id])
    @question = @assessment_answer.question
    @activity = @question.activity
    
    if @assessment_answer.update_attributes(assessment_answer_params)
      if params[:commit].eql?("Save and exit")
        redirection = assessment_path(@assessment)
      else
        next_question = @question.next
        redirection = next_question.blank? ? assessment_path(@assessment) : assessment_question_path(@assessment, next_question)
      end
      redirect_to redirection
    else
      @dimension = @activity.dimension
      @previous_answer = @assessment_answer.prev
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