class OrganisationImporter
  def self.populate(results)
    results.each { |result| create_organisation(result, nil) }
  end

  def self.create_organisation(result, parent)
    org = Organisation.create(parent: parent, name: result['name'], title: result['title'], dgu_id: result['id'])
    parent = org.id if parent.nil?
    result['children'].each { |child| create_organisation(child, parent) }
  end
end