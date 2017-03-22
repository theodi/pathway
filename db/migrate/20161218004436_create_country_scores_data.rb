class CreateCountryScoresData < ActiveRecord::Migration
  def change
    create_table :country_scores_data do |t|
      t.string :name
      t.string :data
      
      t.timestamps null: false
    end
    add_index :country_scores_data, :name, unique: true
  end
end
