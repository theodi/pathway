class AddAssessmentIdToAssessmentAnswers < ActiveRecord::Migration
  def change
    add_reference :assessment_answers, :assessment, index: true
    add_foreign_key :assessment_answers, :assessments
  end
end
