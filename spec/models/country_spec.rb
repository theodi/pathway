require 'rails_helper'

RSpec.describe Country, type: :model do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        country = FactoryGirl.build(:country)
        country.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not validate an empty name" do
        country = FactoryGirl.build(:country, name: "")
        country.should_not be_valid
      end
      it "should not validate an empty code" do
        country = FactoryGirl.build(:country, code: "")
        country.should_not be_valid
      end

      it "should not support duplicates" do
        country = FactoryGirl.build(:country)
        country.save
        country2 = FactoryGirl.build(:country)
        country2.should_not be_valid
      end
    end

  end
end
