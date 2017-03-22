class CreateCountryScores < ActiveRecord::Migration
  def change
    create_table :country_scores do |t|

      t.timestamps null: false
    end
  end
end
