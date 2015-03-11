class AssessmentsController < ApplicationController
  def index
    @assessments = current_user.assessments.order(:completion_date)
  end
end
