class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :assessment_answer, index: true
      t.string :link
      t.string :text

      t.timestamps null: false
    end
    add_foreign_key :links, :assessment_answers
  end
end
