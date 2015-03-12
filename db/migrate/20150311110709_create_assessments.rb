class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.references :user, index: true
      t.datetime :start_date
      t.datetime :completion_date
      t.string :title
      t.string :notes

      t.timestamps null: false
    end
    add_foreign_key :assessments, :users
  end
end
