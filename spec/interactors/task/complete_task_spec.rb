require 'fast_spec_helper'
require 'ostruct'
require 'task_interactors/complete_task'
require 'activity_service'

describe TaskInteractors::CompleteTask do
  before :each do
    user = OpenStruct.new id: 1
    @service = double('Class:TaskPositionService', remove: nil)
    @data = OpenStruct.new id: 1, title: 'Test', completed: false, position: 3
    allow(@data).to receive(:save!).and_return(@data)
    @task = double('Class:Task', find: @data)
    @interactor = TaskInteractors::CompleteTask.new(user, @data.id)
    @interactor.task = @task
    @interactor.task_position_service = @service
    @interactor.new_activity_service = ActivityService.new
  end
  
  context "Error" do
    it "Should complain if task is already completed" do
      @data.completed = true
      expect { @interactor.run }.to raise_error(ArgumentError, 'Task is already completed')
    end
  end
  
  context "Success" do
    let(:ref_time) { Time.now }
    
    before :each do
      zone = double('Class.TimeZone', now: ref_time)
      time = double('Class.Time', zone: zone)
      @interactor.time = time
      @result = @interactor.run
    end
    
    it "Should save the task" do
      expect(@data).to have_received(:save!)
    end
    
    it "Should remove position upon completion" do
      expect(@service).to have_received(:remove)
    end
    
    it "Should set completed" do
      expect(@result.completed).to be_true
      expect(@result.completed_at).to eq(ref_time)
    end
  end
end