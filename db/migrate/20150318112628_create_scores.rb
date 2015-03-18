class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :assessment_id
      t.integer :activity_id
      t.integer :score
      t.integer :target

      t.timestamps null: false
    end
  end
end
