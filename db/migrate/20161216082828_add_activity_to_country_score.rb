class AddActivityToCountryScore < ActiveRecord::Migration
  def change
    add_reference :country_scores, :activity, index: true
    add_foreign_key :country_scores, :activities
  end
end
