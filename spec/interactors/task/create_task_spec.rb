require 'fast_spec_helper'
require 'ostruct'
require 'task_interactors/create_task'
require 'activity_service'

describe TaskInteractors::CreateTask do
  # Our interactors are fast-spec-ed. This means no dependency on ActiveRecord.
  # We count on ActiveRecord for some validations. This is a problem, as we cannot
  # include all "Error"-conditions in this spec.
  
  # context "Error" do
  #   subject { TaskInteractors::CreateTask.new("").run }
  # 
  #   it "Should not create task with empty title" do
  #     expect { subject }.to raise_error(ArgumentError, "Title can't be blank")
  #   end
  # end
  
  context "Success" do
    before :each do
      @data = OpenStruct.new
      allow(@data).to receive(:save!).and_return(@data)
      allow(@data).to receive(:updated_at).and_return(Time.now)
      @service = double('Class:TaskPositionService', append: nil)
      @task = double('Class:Task', new: @data)
      
      @activity = ActivityService.new
      allow(@activity).to receive(:log!).and_return(nil)
      @activity_service = double('Class:ActivityService', new: @activity)
      
      user = OpenStruct.new id: 1
      @interactor = TaskInteractors::CreateTask.new(user, "My task")
      @interactor.task_position_service = @service
      @interactor.task = @task
      @interactor.new_activity_service = @activity
      @result = @interactor.run
    end

    it "Should create task as open" do
      expect(@result.title).to eq("My task")
      expect(@result.completed).to be_false
    end
    
    it "Should get saved" do
      expect(@data).to have_received(:save!)
    end
    
    it "Should be put at the end of the list" do
      expect(@service).to have_received(:append)
    end
    
    it "Should log an activity" do
      expect(@activity).to have_received(:log!)
      expect(@activity.action).to eq(@interactor.class.name)
      expect(@activity.user).to eq(1)
      expect(@activity.related_objects.length).to eq(1)
    end
  end
  
end
