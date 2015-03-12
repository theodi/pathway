class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :code
      t.integer :activity_id
      t.integer :questionnaire_id
      t.string :text
      t.string :notes
      t.references :dependency 
      
      t.timestamps null: false
    end
  end
end
