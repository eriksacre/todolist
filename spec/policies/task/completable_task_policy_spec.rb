require "fast_spec_helper"
require "ostruct"
require "task_policies/completable_task_policy"

describe TaskPolicies::CompletableTaskPolicy do
  context "Completable task" do
    let(:task) { OpenStruct.new(title: "First task", completed: false) }
    subject { TaskPolicies::CompletableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_true }
    it { expect {subject.enforce }.not_to raise_error }
  end
  
  context "Not completable" do
    let(:task) { OpenStruct.new(title: "First task", completed: true, completed_at: Time.now) }
    subject { TaskPolicies::CompletableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_false }
    it { expect(subject.description).to eq("Task is already completed") }
    it { expect { subject.enforce }.to raise_error(ArgumentError, subject.description) }
  end
end
