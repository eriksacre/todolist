require 'fast_spec_helper'
require 'ostruct'
require 'task_interactors/update_task_position'
require 'activity_service'

describe TaskInteractors::UpdateTaskPosition do
  class PositionService
    def move(task, new_position)
      task.position = new_position
    end
  end
  
  # TODO: Remove duplication
  before :each do
    user = OpenStruct.new id: 1
    @data = OpenStruct.new id: 1, title: 'Test', position: 3
    allow(@data).to receive(:save!).and_return(@data)
    @task = double('Class:Task', find: @data)
    @activity = ActivityService.new
    @interactor = TaskInteractors::UpdateTaskPosition.new(user, @data.id, 5)
    @interactor.task = @task
    @interactor.new_activity_service = @activity
    @interactor.task_position_service = PositionService.new
    @interactor.run
  end
  
  it "Logs the old and new position" do
    expect(@activity.parameters[:position][:old_value]).to eq(3)
    expect(@activity.parameters[:position][:new_value]).to eq(5)
  end
end
