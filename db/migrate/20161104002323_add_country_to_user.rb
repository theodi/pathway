class AddCountryToUser < ActiveRecord::Migration
  def change
    add_reference :users, :country, index: true
    add_foreign_key :users, :countries
  end
end
