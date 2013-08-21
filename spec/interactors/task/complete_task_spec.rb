require 'fast_spec_helper'
require 'data_object'
require 'task_interactors/complete_task'

describe TaskInteractors::CompleteTask do
  let(:task) { DataObject.new id: 1, title: 'Test', completed: false, position: 3 }
  subject { TaskInteractors::CompleteTask.new(task.id) }
  before(:each) { mock_finder 'Task', task }
  
  context "Error" do
    it "Should complain if task is already completed" do
      task.completed = true
      expect { subject.run }.to raise_error(ArgumentError, 'Task is already completed')
    end
  end
  
  context "Success" do
    let(:result) { subject.run }
    let(:ref_time) { Time.now }
    
    before :each do
      zone = Class.new
      stub_const('TimeZone', zone)
      zone.should_receive(:now).and_return(ref_time)
      
      time = Class.new
      stub_const('Time', time)
      time.should_receive(:zone).and_return(zone)
      
      service = Class.new
      stub_const('TaskPositionService', service)
      service.should_receive(:remove)
    end
    
    it "Should save the task" do
      result.has_saved.should be_true
    end
    
    it "Should remove position upon completion" do
      # Tested by should_receive(:remove)
      result
    end
    
    it "Should set completed" do
      result.completed.should be_true
      result.completed_at.should == ref_time
    end
  end
end