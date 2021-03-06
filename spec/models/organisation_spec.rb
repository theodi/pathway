require 'spec_helper'

describe Organisation do

  describe "self.dgu" do
    it "should only return dgu Organisations" do
      FactoryGirl.create(:organisation, title: "Non-DGU organisation", dgu_id: nil)
      FactoryGirl.create(:organisation, title: "DGU orginisation", dgu_id: 123)

      expect(Organisation.dgu.count).to eq(1)
      expect(Organisation.dgu.first.title).to eq("DGU orginisation")
    end
  end

  describe "#set_name" do
    it "should set a name slug on create" do
      o = Organisation.new
      o.title = "Department of Stuff"
      o.save
      expect(o.name).to eq("department-of-stuff")
    end
  end

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
