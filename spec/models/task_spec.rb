require 'spec_helper'

describe Task do
  TASK_COUNT = 20
  COMPLETE_COUNT = 15
  REMAINING_COUNT = TASK_COUNT - COMPLETE_COUNT
  
  context "More than limited number of tasks" do
    before :each do
      (1..TASK_COUNT).each do |n|
        task = TaskInteractors::CreateTask.new("Task #{n}").run
        TaskInteractors::CompleteTask.new(task.id).run if n <= COMPLETE_COUNT
      end
    end
  
    context "Remaining tasks" do
      subject { Task.todo }
    
      it "Returns all remaining tasks" do
        expect(subject.length).to eq(REMAINING_COUNT)
      end
    
      it "Only returns remaining tasks" do
        subject.each do |task|
          expect(task.completed).to be_false
        end
      end
    end
  
    context "Completed tasks" do
      it "Returns limited number of completed tasks" do
        expect(Task.limited_completed.length).to eq(Task::MAX_COMPLETED)
      end
    
      it "Returns the number of completed tasks" do
        expect(Task.completed_count).to eq(COMPLETE_COUNT)
      end
    
      it "Returns all completed tasks" do
        expect(Task.completed.length).to eq(COMPLETE_COUNT)
      end
    
      it "Indicates there are more completed tasks than returned by default" do
        expect(Task.more?).to be_true
      end
    end
  end
  
  context "Fewer than limited number of tasks" do
    before :each do
      task = TaskInteractors::CreateTask.new("Sole task").run
      TaskInteractors::CompleteTask.new(task.id).run
    end
    
    it "Indicates there aren't more tasks" do
      expect(Task.more?).to be_false
    end
  end
end
