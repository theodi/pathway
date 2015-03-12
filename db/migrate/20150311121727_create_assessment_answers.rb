class CreateAssessmentAnswers < ActiveRecord::Migration
  def change
    create_table :assessment_answers do |t|
      t.references :question, index: true
      t.references :answer, index: true
      t.text :notes

      t.timestamps null: false
    end
    add_foreign_key :assessment_answers, :questions
    add_foreign_key :assessment_answers, :answers
  end
end
