class AddStatsToCountryScores < ActiveRecord::Migration
  def change
    add_column :country_scores, :initial, :integer
    add_column :country_scores, :repeatable, :integer
    add_column :country_scores, :defined, :integer
    add_column :country_scores, :managed, :integer
    add_column :country_scores, :optimising, :integer
  end
end