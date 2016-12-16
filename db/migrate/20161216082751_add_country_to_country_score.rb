class AddCountryToCountryScore < ActiveRecord::Migration
  def change
    add_reference :country_scores, :country, index: true
    add_foreign_key :country_scores, :countries
  end
end
