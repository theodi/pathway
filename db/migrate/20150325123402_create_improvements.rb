class CreateImprovements < ActiveRecord::Migration
  def change
    create_table :improvements do |t|
      t.string :code
      t.references :answer, index: true
      t.text :notes

      t.timestamps null: false
    end
  end
end
