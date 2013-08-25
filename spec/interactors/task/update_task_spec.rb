require 'fast_spec_helper'
require 'ostruct'
require 'task_interactors/update_task'

describe TaskInteractors::UpdateTask do
  before :each do
    @data = OpenStruct.new id: 1, title: 'Test'
    allow(@data).to receive(:save!).and_return(@data)
    @task = double('Class:Task', find: @data)
    @interactor = TaskInteractors::UpdateTask.new(@data.id, "Brand new title")
    @interactor.task = @task
  end
  
  context "Error" do
    before :each do
      @data.completed = true
    end
    
    it { expect {@interactor.run }.to raise_error(ArgumentError, "Cannot modify completed task") }
  end
  
  context "Success" do
    before :each do
      @data.completed = false
    end
    
    it { expect(@interactor.run.title).to eq("Brand new title") }
  end
  
end