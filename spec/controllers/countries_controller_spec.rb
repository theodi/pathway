require 'rails_helper'

RSpec.describe CountriesController, type: :controller do
  it "should query a country by name" do
    FactoryGirl.create(:country, name: "A Made up Country", code: "am")
    FactoryGirl.create(:country, name: "Another made up Island", code: "ai")

    get "index", q: "Ano", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first["text"]).to eq("Another made up Island")
  end

  it "should query a country by name regardless of case" do
    FactoryGirl.create(:country, name: "A Made up Country", code: "am")
    FactoryGirl.create(:country, name: "Another made up Island", code: "ai")

    get "index", q: "ano", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first["text"]).to eq("Another made up Island")
  end

  it "should return json keys text and id" do
    FactoryGirl.create(:country, name: "A Made up Country", code: "am")
    FactoryGirl.create(:country, name: "Another made up Island", code: "ai")

    get "index", q: "Ano", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first.keys).to eq(["id", "text"])
  end

  it "returns country name as it appears in database" do
    FactoryGirl.create(:country, name: "a made-up country", code: "am")

    get "index", q: "A mad", format: "json"

    results = JSON.parse(response.body)

    expect(results.count).to eq(1)
    expect(results.first["text"]).to eq("a made-up country")
  end
end
