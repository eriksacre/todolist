require 'spec_helper'

describe "/api/v1/me", type: :api do
  before(:each) { json_api }
  let(:user) { FactoryGirl.create(:user) }
  let(:url) { "/api/v1/me" }
  
  it "should return 401 (Not authorized) when not passing in a basic authentication header" do
    get url
    expect(response.code).to eq "401"
  end
  
  it "should return 401 when passing in an invalid username" do
    http_authenticate('nobody', 'secret')
    get url, {}, @env
    expect(response.code).to eq "401"
  end
  
  it "should return a response containing the api_token for a valid username/password combination" do
    http_authenticate(user.email, user.password)
    get url, {}, @env
    expect(response.code).to eq "200"
    expect(json["email"]).to eq user.email
    expect(json["api_token"]).to eq user.api_token
  end
end
