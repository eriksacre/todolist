require 'spec_helper'

describe "/api/v1/me", type: :api do
  before(:each) { json_api }
  let(:user) { FactoryGirl.create(:user) }
  let(:url) { "/api/v1/me" }
  
  it "should return 401 (Not authorized) when not passing in a basic authentication header" do
    get url
    response.code.should == "401"
  end
  
  it "should return 401 when passing in an invalid username" do
    http_authenticate('nobody', 'secret')
    get url, {}, @env
    response.code.should == "401"
  end
  
  it "should return a response containing the api_token for a valid username/password combination" do
    http_authenticate(user.email, user.password)
    get url, {}, @env
    response.code.should == "200"
    json["email"].should == user.email
    json["api_token"].should == user.api_token
  end
end
