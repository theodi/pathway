require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET #new" do
    it "should new user to view the sign up page" do
      get :new
      response.should be_success
    end
  end
  
  describe "POST #create" do
    it "should allow a new user to be created with an organisation" do
      expect{  
        post :create, user: FactoryGirl.attributes_for(:user), organisation: "British Waterways"
      }.to change(User,:count).by(1)
    end

    it "should allow a new user to be created without an organisation" do
      expect{
        post :create, user: FactoryGirl.attributes_for(:user), organisation: ""
      }.to change(User,:count).by(1)
    end
  end

end