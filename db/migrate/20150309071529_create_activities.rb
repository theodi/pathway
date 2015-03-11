class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :title
      t.integer :dimension_id
      t.integer :questionnaire_id

      t.timestamps null: false
    end
  end
end
