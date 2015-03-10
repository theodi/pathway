require 'spec_helper'

describe User do

  describe "#associated_organisation=" do
    it "should create a valid organisation and associate it with the user" do
      user = FactoryGirl.build(:user)
      user.associated_organisation = "Department of Social Affairs and Citizenship"
      user.associated_organisation.persisted?.should be_truthy
    end
  end

  describe "creation" do
    context "valid attributes" do
      it "should be valid" do
        user = FactoryGirl.build(:user)
        user.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        user = FactoryGirl.build(:user, email: "")
        user.should_not be_valid
      end

      it "should not allow more than one user to be associated with the same organisation" do
        user = FactoryGirl.build(:user)
        organisation = FactoryGirl.create(:organisation)
        user.organisation = organisation
        user.save

        user2 = FactoryGirl.build(:user, email: "user2@example.org")
        user2.associated_organisation = "Department for Environment, Food and Rural Affairs"
        user2.should_not be_valid
      end
    end
  end

end
