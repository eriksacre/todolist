require 'fast_spec_helper'
require 'task_interactors/create_task'

describe TaskInteractors::CreateTask do
  before :each do
    mock_model 'Task'
  end
  
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
    subject { TaskInteractors::CreateTask.new("My task").run }
    
    before :each do
      service = Class.new
      stub_const('TaskPositionService', service)
      service.should_receive(:append)
    end
    
    it "Should create task as open" do
      subject.title.should == "My task"
      subject.completed.should be_false
    end
    
    it "Should get saved" do
      subject.has_saved.should be_true
    end
    
    it "Should be put at the end of the list" do
      subject # Tested via should_receive :append
    end
  end
  
end
