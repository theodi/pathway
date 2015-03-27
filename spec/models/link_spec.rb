require 'spec_helper'

describe Link do

  it "should contain a valid url" do
    link = FactoryGirl.build(:link)
    expect(link.valid?).to eq(true)
  end

  it "should not contain a valid url" do
    link = FactoryGirl.build(:link, link: "blah")
    expect(link.valid?).to eq(false)
  end

end
