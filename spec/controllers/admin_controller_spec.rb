require 'spec_helper'

describe AdminController do
  
  it "should allow an admin to view admin pages" do
    sign_in FactoryGirl.create(:admin)
    get "index"
    response.should be_success
  end
  
  it "should not allow other users to view admin pages" do
    sign_in FactoryGirl.create(:user)
    get "index"
    response.code.should eql("302")
  end
  
end