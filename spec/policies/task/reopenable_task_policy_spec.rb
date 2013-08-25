require "fast_spec_helper"
require "ostruct"
require "task_policies/reopenable_task_policy"

describe TaskPolicies::ReopenableTaskPolicy do
  context "Reopenable task" do
    let(:task) { OpenStruct.new(title: "First task", completed: true, completed_at: Time.now) }
    subject { TaskPolicies::ReopenableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_true }
    it { expect {subject.enforce }.not_to raise_error }
  end
  
  context "Not reopenable" do
    let(:task) { OpenStruct.new(title: "First task", completed: false) }
    subject { TaskPolicies::ReopenableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_false }
    it { expect(subject.description).to eq("Task is already open") }
    it { expect { subject.enforce }.to raise_error(ArgumentError, subject.description) }
  end
end
