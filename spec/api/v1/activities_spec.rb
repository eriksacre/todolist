require 'spec_helper'

describe "/api/v1/activities", type: :api do
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { user.api_token }
  
  before(:each) do
    json_api
    http_authenticate_by_token(token)
  end
  
  context "List of activities" do
    let(:url) { "/api/v1/activities" }
    let(:since) { "?since=2013-08-28T17:09:32%2b0200" }
    
    it "should return error if since-parameter is missing" do
      get url, {}, @env
      expect(response.code).to eq("400")
    end
    
    it "should return an empty array if there are no activities" do
      get url + since, {}, @env
      expect(response.code).to eq("200")
      expect(json.length).to eq(0)
    end
    
    it "should return an array of activities" do
      generate_activities
      
      get url + since, {}, @env
      expect(response.code).to eq("200")
      expect(json.length).to eq(5)
      
      expect(json[0]).to eq(
        "user" => { "id" => user.id, "email" => user.email },
        "recorded_at" => @t1.updated_at.to_formatted_s(:iso8601),
        "action" => "created",
        "subject" => { "title" => @t1.title, "url" => api_v1_task_url(@t1.id) } # Problem: not easy to get slug for related objects!
      )
    end
    
    it "returns maximum 50 activities" do
      generate_100_activities
      
      get url + since, {}, @env
      expect(response.code).to eq("200")
      expect(json.length).to eq(50)
    end
    
    def generate_activities
      @t1 = TaskInteractors::CreateTask.new(user, "First task").run
      t2 = TaskInteractors::CreateTask.new(user, "Second task").run
      t3 = TaskInteractors::CreateTask.new(user, "Third task").run
      TaskInteractors::CompleteTask.new(user, t2.id).run
      TaskInteractors::UpdateTaskPosition.new(user, t3.id, 0).run
    end
    
    def generate_100_activities
      (1..100).each do |n|
        TaskInteractors::CreateTask.new(user, "Task #{n}").run
      end
    end
  end
end
