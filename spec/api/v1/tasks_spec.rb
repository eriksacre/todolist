require 'spec_helper'

describe "/api/v1/tasks", type: :api do
  before(:each) { json_api }
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { user.api_token }
  
  context "Bad authentication" do
    let(:url) { "/api/v1/tasks" }

    it "should return 401 when not passing a token" do
      get url
      response.code.should == "401"
    end
    
    it "should return 401 when passing an unknown token" do
      http_authenticate_by_token("unknown_token")
      get url, {}, @env
      response.code.should == "401"
    end
  end
  
  context "Properly authenticated" do
    before(:each) { http_authenticate_by_token(token) }

    context "List of tasks" do
      let(:url) { "/api/v1/tasks" }
      before(:each) do
        (1..5).each do |n|
          task = TaskInteractors::CreateTask.new("Task #{n}").run
          TaskInteractors::CompleteTask.new(task.id).run if n <= 2
        end
      end

      it "should return the list of tasks" do
        get url, {}, @env
        response.code.should == "200"

        json["todo"].length.should == 3
        json["completed"].length.should == 2
        json["todo"].any? do |t|
          t["title"] == "Task 4"
        end.should be_true
        json["todo"].any? do |t|
          t["title"] == "Task 1"
        end.should be_false
      end
    end
    
    context "creating a task" do
      let(:url) { "/api/v1/tasks" }
      
      it "Valid task" do
        post url, { title: "New task" }.to_json, @env

        response.code.should == "201"
        json["title"].should == "New task"
        json["completed"].should be_false
      end
      
      it "Invalid task" do
        post url, { title: "" }.to_json, @env
        
        response.code.should == "422"
        json.should == [ { "error" => "Title can't be blank" } ]
      end
      
      it "Bad request" do
        post url, { titlex: "" }.to_json, @env
        
        response.code.should == "400"
        json.should == { "error" => "Request does not contain a valid combination of attributes" }
      end
    end
    
    context "modifying an open task" do
      let(:task) { TaskInteractors::CreateTask.new("Test").run }
      let(:url) { "/api/v1/tasks/#{task.id}" }
      
      it "Updates the title" do
        put url, { title: "Updated" }.to_json, @env
        response.code.should == "200"
        json["title"].should == "Updated"
      end
      
      it "Updates the position" do
        put url, { position: 1 }.to_json, @env
        response.code.should == "200"
        json["position"].should == 1
      end
      
      it "Completes the task" do
        put url, { completed: true }.to_json, @env
        response.code.should == "200"
        json["completed"].should == true
      end
      
      it "Does not reopen an already open task" do
        put url, { completed: false }.to_json, @env
        response.code.should == "400"
        json.should == { "error" => "Task is already open" }
      end
      
      it "Does not accept certain combination of attributes" do
        put url, { title: "Updated", position: 3 }.to_json, @env
        response.code.should == "400"
        json.should == { "error" => "Request does not contain a valid combination of attributes" }
      end
    end
  end
end
