require 'spec_helper'

describe User do
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
        user2.associate_organisation("Department for Environment, Food and Rural Affairs")
        user2.should_not be_valid
      end
    end

  end
end
