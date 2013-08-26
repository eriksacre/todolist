require "spec_helper"

describe ActivityService do

  context "Building an Activity" do
    it "has attributes for user, activity and recorded_at" do
      rec_time = Time.now
    
      service = ActivityService.new.tap do |a|
        a.user = 1
        a.action = "task/create_task"
        a.recorded_at = rec_time
      end
    
      expect(service.user).to eq(1)
      expect(service.action).to eq("task/create_task")
      expect(service.recorded_at).to eq(rec_time)
    end
  
    it "has builder method for tracking parameters" do
      service = ActivityService.new.tap do |a|
        a.add_parameter :name, "Erik"
      end
    
      expect(service.parameters).to have_key(:name)
      expect(service.parameters[:name]).to eq("Erik")
    end
  
    it "has builder method for tracking parameter updates" do
      service = ActivityService.new.tap do |a|
        a.add_parameter :age, 42, 43
      end
    
      expect(service.parameters[:age]).to have_key(:old_value)
      expect(service.parameters[:age][:new_value]).to eq(43)
    end
  
    it "does not accept more than 2 parameter values" do
      service = ActivityService.new.tap do |a|
        expect { a.add_parameter :test, 1, 2, 3 }.to raise_error(ArgumentError)
      end
    end
  
    it "does not accept less than 1 parameter value" do
      service = ActivityService.new.tap do |a|
        expect { a.add_parameter :test }.to raise_error(ArgumentError)
      end
    end
  
    it "has a method to get attributes for related object" do
      task = TaskInteractors::CreateTask.new("Some task").run
      service = ActivityService.new.tap do |a|
        a.add_related task
      end
    
      expect(service.related_objects.length).to eq(1)
      expect(service.related_objects[0][:type]).to eq("task")
      expect(service.related_objects[0][:id]).to eq(task.id)
      expect(service.related_objects[0][:title]).to eq(task.title)
    end
  end

  context "Storing the activity in the database" do
    before :each do
      @user = FactoryGirl.create(:user)
      @task = TaskInteractors::CreateTask.new("Some task").run
      @activity = ActivityService.new.tap do |a|
        a.user = @user.id
        a.action = "task_interactors/create_task"
        a.recorded_at = @task.updated_at
        a.add_parameter :title, @task.title
        a.add_related @task
        a.save!
      end
    end
    
    it "Stores the information in the activities table" do
      expect(Activity.all.length).to eq(1)
      
      activity = Activity.limit(1)[0]
      expect(activity.user_id).to eq(@user.id)
      expect(activity.action).to eq("task_interactors/create_task")
      expect(activity.recorded_at).to eq(@task.updated_at)
      expect(JSON.parse(activity.info)).to eq({
        "parameters" => {
          "title" => @task.title
        },
        "related_objects" => [
          {
            "type" => "task",
            "id" => @task.id,
            "title" => @task.title
          }
        ]
      })
    end
  end
end