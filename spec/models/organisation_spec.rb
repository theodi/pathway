require 'spec_helper'

describe Organisation do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        organisation = FactoryGirl.build(:organisation)
        organisation.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        organisation = FactoryGirl.build(:organisation, title: "")
        organisation.should_not be_valid
      end

      it "should not support duplicates" do
        organisation = FactoryGirl.build(:organisation)
        organisation.save
        organisation2 = FactoryGirl.build(:organisation)
        organisation2.should_not be_valid
      end
    end

  end
end
