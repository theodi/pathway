require 'spec_helper'

describe OrganisationsController do

  it "should query an organisation by title" do
    FactoryGirl.create(:organisation, name: "my-terrrible-organisation", title: "My Terrible Organisation")
    FactoryGirl.create(:organisation, name: "my-fantastic-organisation", title: "My Fantastic Organisation")

    get "index", q: "fantastic", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first["text"]).to eq("My Fantastic Organisation")
  end

  it "should be limited to DGU organisations" do
    FactoryGirl.create(:organisation, name: "my-fantastic-organisation", title: "My Fantastic Organisation")
    FactoryGirl.create(:organisation, name: "another-fantastic-organisation", title: "Another Fantastic Organisation", dgu_id: nil)

    get "index", q: "fantastic", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first["text"]).to eq("My Fantastic Organisation")
  end

end
