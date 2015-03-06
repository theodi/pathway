require 'spec_helper'
require 'organisation_importer'

describe OrganisationImporter do 
  describe '.populate' do 

    before(:all) do
      file = File.read('spec/lib/defra.json')
      json = JSON.parse(file)
      @results = json['result']
      OrganisationImporter.populate(@results)
    end

    after(:all) do
      Organisation.destroy_all
    end

    it "should create new organisations from example JSON" do
      expect(Organisation.count).to eq(14)
    end

    it "should only create one top level organisation from example JSON" do
      expect(Organisation.where(parent: nil).count).to eq(1)
    end

    it "should not create duplicate entries" do
      count = Organisation.count
      OrganisationImporter.populate(@results)
      expect(Organisation.count).to eq(count)
    end

  end
end