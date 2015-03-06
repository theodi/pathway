class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :title
      t.string :dgu_id
      t.integer :parent

      t.timestamps null: false
    end
  end
end
