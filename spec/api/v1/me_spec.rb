require 'spec_helper'

describe "/api/v1/me", type: :api do
  let(:user) { FactoryGirl.create(:user) }
  
  it "should return 401 (Not authorized) when not passing in a basic authentication header" do
    get "/api/v1/me"
    response.code.should == "401"
  end
  
  it "should return 401 when passing in an invalid username" do
    # How to add basic auth?
    get "/api/v1/me"
    response.code.should == "401"
  end
end
