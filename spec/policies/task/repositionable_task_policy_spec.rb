require "fast_spec_helper"
require "ostruct"
require "task_policies/repositionable_task_policy"

describe TaskPolicies::RepositionableTaskPolicy do
  context "Repositionable task" do
    let(:task) { OpenStruct.new(title: "First task", completed: false, position: 0) }
    subject { TaskPolicies::RepositionableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_true }
    it { expect {subject.enforce }.not_to raise_error }
  end
  
  context "Not repositionable" do
    let(:task) { OpenStruct.new(title: "First task", completed: true) }
    subject { TaskPolicies::RepositionableTaskPolicy.new(task) }
    
    it { expect(subject.comply?).to be_false }
    it { expect(subject.description).to eq("A completed task does not have a position") }
    it { expect { subject.enforce }.to raise_error(ArgumentError, subject.description) }
  end
end
