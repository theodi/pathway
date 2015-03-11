class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.integer :version
      t.string :notes

      t.timestamps null: false
    end
    add_index(:questionnaires, :version, unique: true)
  end
end
