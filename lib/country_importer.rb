class CountryImporter
  def self.populate(results)
    results.each { |result| Country.create(name: result['Name'], code: result['Code'].downcase) }
  end
end
