require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET #new" do
    it "should new user to view the sign up page" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    attrs = FactoryGirl.attributes_for(:user, associated_organisation: "DoSAC")
    it "should allow a new user to be created with a new organisation" do
      expect{
        post :create, user: attrs
      }.to change(User,:count).by(1)
    end

    it "should create a new organisation for the user" do
      attrs = FactoryGirl.attributes_for(:user, associated_organisation: "DoSAC")
      expect{
        post :create, user: attrs
      }.to change(Organisation,:count).by(1)
    end

    it "should create a new user, but not a new country" do
      attrs = FactoryGirl.attributes_for(:user, associated_country: "foobar")
      expect{
        post :create, user: attrs
      }.to change(User,:count).by(1).and change(Country,:count).by(0)
    end

    it "should allow a new user to be created with an existing organisation" do
      FactoryGirl.create(:organisation)
      expect{
        post :create, user: FactoryGirl.attributes_for(:user), associated_organisation: "Department for Environment, Food and Rural Affairs"
      }.to change(User,:count).by(1)
    end

    it "should allow a new user to be created with an existing country" do
      FactoryGirl.create(:organisation)
      expect{
        post :create, user: FactoryGirl.attributes_for(:user), associated_country: "United Kingdom"
      }.to change(User,:count).by(1)
    end

    it "should allow a new user to be created without an organisation" do
      expect{
        post :create, user: FactoryGirl.attributes_for(:user), associated_organisation: ""
      }.to change(User,:count).by(1)
    end

    it "should allow a new user to be created without a country" do
      expect{
        post :create, user: FactoryGirl.attributes_for(:user), associated_country: ""
      }.to change(User,:count).by(1)
    end
  end

end
