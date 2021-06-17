require 'country_importer'
require 'net/http'

namespace :countries do

  desc "Imports countries from from a source which keeps up to date with ISO 3166-1"
  task :import => :environment do
    url = URI.parse("https://raw.githubusercontent.com/datasets/country-list/master/data.csv")
    response = Net::HTTP.get(url)
    results = CSV.parse(response.force_encoding("UTF-8"), :headers => true)
    puts "#{results.length} countries found"
    CountryImporter.populate(results)
  end

end
