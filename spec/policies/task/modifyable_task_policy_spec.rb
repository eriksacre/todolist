require "fast_spec_helper"
require "ostruct"
require "task_policies/modifyable_task_policy"

describe TaskPolicies::ModifyableTaskPolicy do
  context "Modifyable task" do
    let(:task) { OpenStruct.new(title: "First task", completed: false) }
    subject { TaskPolicies::ModifyableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_true }
    it { expect {subject.enforce }.not_to raise_error }
  end
  
  context "Not modifyable" do
    let(:task) { OpenStruct.new(title: "First task", completed: true, completed_at: Time.now) }
    subject { TaskPolicies::ModifyableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_false }
    it { expect(subject.description).to eq("Cannot modify completed task") }
    it { expect { subject.enforce }.to raise_error(ArgumentError, subject.description) }
  end
end
