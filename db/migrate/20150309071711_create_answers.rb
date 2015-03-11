class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :code
      t.integer :question_id
      t.integer :questionnaire_id
      t.string :text
      t.string :notes
      t.boolean :positive, :default => false
      t.integer :score

      t.timestamps null: false
    end
  end
end
