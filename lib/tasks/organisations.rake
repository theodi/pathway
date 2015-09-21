require 'organisation_importer'

namespace :organisations do

  #work around that heroku schedule only allows up to daily
  task :weekly_import => :environment do
    if Time.now.monday?
      Rake::Task["organisations:import"].execute
    end
  end

  desc "Imports organisations from the data.gov.uk hierarchy"
  task :import => :environment do
    uri = URI("https://data.gov.uk/api/action/group_tree?type=organization")
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    results = json['result']
    puts "#{results.length} top level organisations found"
    OrganisationImporter.populate(results)
  end

end
