require 'spec_helper'
require "cancan/matchers"

describe User do

  describe "#associated_organisation=" do
    it "should create a valid organisation and associate it with the user" do
      user = FactoryGirl.build(:user)
      user.associated_organisation = "Department of Social Affairs and Citizenship"
      expect(user.associated_organisation.persisted?).to be_truthy
    end
  end

  describe "#associated_country=" do
    it "should create a valid country and associate it with the user" do
      user = FactoryGirl.build(:user)
      country = FactoryGirl.create(:country)
      user.country = country
      expect(user.associated_country.persisted?).to be_truthy
    end
  end

  describe '#current_assessment' do
    it "should return the asssessment that has not been completed" do
      user = FactoryGirl.create(:user)
      a = user.assessments.create(FactoryGirl.attributes_for(:unfinished_assessment))
      expect(user.current_assessment).to eql(a)
    end

    it "should return nil when all assessments have been completed" do
      user = FactoryGirl.create(:user)
      a = user.assessments.create(FactoryGirl.attributes_for(:assessment))
      expect(user.current_assessment).to eql(nil)
    end
  end

  describe "creation" do
    context "valid attributes" do
      it "should be valid" do
        user = FactoryGirl.build(:user)
        expect(user).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        user = FactoryGirl.build(:user, email: "")
        expect(user).to_not be_valid
      end

      it "should not allow more than one user to be associated with the same organisation" do
        user = FactoryGirl.build(:user)
        organisation = FactoryGirl.create(:organisation)
        user.organisation = organisation
        user.save

        user2 = FactoryGirl.build(:user, email: "user2@example.org")
        user2.associated_organisation = "Department for Environment, Food and Rural Affairs"
        expect(user2).to_not be_valid
      end
    end
  end

  describe 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:assessment) { user.assessments.create(FactoryGirl.attributes_for(:assessment)) }

    subject(:ability) { Ability.new(user) }

    it { should be_able_to :manage, assessment }
  end

end
