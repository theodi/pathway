# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user = User.find_or_create_by!(email: ENV["ADMIN_EMAIL"] ) do |user|
  user.password =  ENV["ADMIN_PASSWORD"]
  user.password_confirmation = ENV["ADMIN_PASSWORD"]
  user.terms_of_service = "1"
  user.name = "Pathway Administrator"
  user.admin = true
end
user.save!