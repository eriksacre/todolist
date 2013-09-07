require 'spec_helper'

describe "/api/v1/tasks", type: :api do
  before(:each) { json_api }
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { user.api_token }
  
  context "Bad authentication" do
    let(:url) { "/api/v1/tasks" }

    it "should return 401 when not passing a token" do
      get url
      expect(response.code).to eq "401"
    end
    
    it "should return 401 when passing an unknown token" do
      http_authenticate_by_token("unknown_token")
      get url, {}, @env
      expect(response.code).to eq "401"
    end
  end
  
  context "Properly authenticated" do
    before(:each) { http_authenticate_by_token(token) }

    context "List of tasks" do
      let(:url) { "/api/v1/tasks" }
      before(:each) do
        (1..15).each do |n|
          task = TaskInteractors::CreateTask.new(user, "Task #{n}").run
          TaskInteractors::CompleteTask.new(user, task.id).run if n <= 10
        end
      end

      it "should return the list of tasks" do
        get url, {}, @env
        expect(response.code).to eq "200"

        expect(json[:todo].length).to eq 5
        expect(json[:completed].length).to eq 10
        expect(json[:todo].any? do |t|
          t[:title] == "Task 11"
        end).to be_true
        expect(json[:todo].any? do |t|
          t[:title] == "Task 1"
        end).to be_false
      end
      
      it "returns 304 Not Modified when using If-Modified-Since header" do
        get url, {}, @env
        expect(response.code).to eq "200"
        
        last_modified = response.headers["Last-Modified"]
        expect(last_modified).not_to be_nil
        expect(response.headers).not_to have_key("ETag")

        @env['If-Modified-Since'] = last_modified
        get url, {}, @env
        expect(response.code).to eq "304"
      end
    end
    
    context "creating a task" do
      let(:url) { "/api/v1/tasks" }
      
      it "Valid task" do
        post url, { title: "New task" }.to_json, @env

        expect(response.code).to eq "201"
        expect(json[:title]).to eq "New task"
        expect(json[:completed]).to be_false
        expect(response.headers['Location']).to eq(json[:url])
      end
      
      it "Invalid task" do
        post url, { title: "" }.to_json, @env
        
        expect(response.code).to eq "422"
        expect(json).to eq [ { error: "Title can't be blank" } ]
      end
      
      it "Bad request" do
        post url, { titlex: "" }.to_json, @env
        
        expect(response.code).to eq "400"
        expect(json).to eq({ error: "Request does not contain a valid combination of attributes" })
      end
    end
    
    context "fetching a single open task" do
      let(:task) { TaskInteractors::CreateTask.new(user, "Test").run }
      let(:url) { "/api/v1/tasks/#{task.id}-test"}
      
      it "Fetches the task" do
        get url, {}, @env
        expect(response.code).to eq "200"
        expect(json).to eq({
          id: task.id,
          title: task.title,
          position: 0,
          completed: false,
          url: api_v1_task_url(task)
        })
        expect(response.headers).to have_key("ETag")
        expect(response.headers).to have_key("Last-Modified")
      end
      
      it "Returns 304 Not Modified when using ETag" do
        get url, {}, @env
        expect(response.code).to eq "200"
        etag = response.headers["ETag"]
        expect(etag).not_to be_nil
        expect(response.headers).to have_key('Last-Modified')
        
        @env['If-None-Match'] = etag
        get url, {}, @env
        expect(response.code).to eq "304"
      end
      
      it "Returns modified entity when using ETag" do
        get url, {}, @env
        expect(response.code).to eq "200"
        etag = response.headers["ETag"]
        expect(etag).not_to be_nil
        
        TaskInteractors::CompleteTask.new(user, task.id).run
        
        @env['If-None-Match'] = etag
        get url, {}, @env
        expect(response.code).to eq "200"
      end
    end
    
    context "fetching a single completed task" do
      let(:task) { t = TaskInteractors::CreateTask.new(user, "Test").run; TaskInteractors::CompleteTask.new(user, t.id).run }
      let(:url) { "/api/v1/tasks/#{task.id}-test"}
      
      it "Fetches the task" do
        get url, {}, @env
        expect(response.code).to eq "200"
        expect(json).to eq({
          id: task.id,
          title: task.title,
          completed: true,
          completed_at: task.updated_at.to_formatted_s(:iso8601),
          url: api_v1_task_url(task)
        })
      end
    end
    
    context "modifying an open task" do
      let(:task) { TaskInteractors::CreateTask.new(user, "Test").run }
      let(:url) { "/api/v1/tasks/#{task.id}" }
      
      it "Updates the title" do
        put url, { title: "Updated" }.to_json, @env
        expect(response.code).to eq "200"
        expect(json[:title]).to eq "Updated"
      end
      
      it "Updates the position" do
        put url, { position: 1 }.to_json, @env
        expect(response.code).to eq "200"
        expect(json[:position]).to eq 1
      end
      
      it "Completes the task" do
        put url, { completed: true }.to_json, @env
        expect(response.code).to eq "200"
        expect(json[:completed]).to eq true
      end
      
      it "Does not reopen an already open task" do
        put url, { completed: false }.to_json, @env
        expect(response.code).to eq "400"
        expect(json).to eq({ error: "Task is already open" })
      end
      
      it "Does not accept certain combination of attributes" do
        put url, { title: "Updated", position: 3 }.to_json, @env
        expect(response.code).to eq "400"
        expect(json).to eq({ error: "Request does not contain a valid combination of attributes" })
      end
    end
    
    context "modifying a completed task" do
      let(:task) { t = TaskInteractors::CreateTask.new(user, "Test").run; TaskInteractors::CompleteTask.new(user, t.id).run }
      let(:url) { "/api/v1/tasks/#{task.id}" }
      
      it "Does not permit updating the position" do
        put url, { position: 1 }.to_json, @env
        expect(response.code).to eq "400"
        expect(json).to eq({ error: "A completed task does not have a position" })
      end
      
      it "Does not permit completing the task" do
        put url, { completed: true }.to_json, @env
        expect(response.code).to eq "400"
        expect(json).to eq({ error: "Task is already completed" })
      end
      
      it "Reopens the task" do
        put url, { completed: false }.to_json, @env
        expect(response.code).to eq "200"
        expect(json[:completed]).to be_false
      end
    end
    
    context "deleting a task" do
      let(:task) { TaskInteractors::CreateTask.new(user, "Test").run }
      let(:url) { "/api/v1/tasks/#{task.id}" }
      
      it "Deletes the task" do
        delete url, {}, @env
        expect(response.code).to eq "204"
        expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
