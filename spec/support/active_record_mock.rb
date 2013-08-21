module ActiveRecordMock
  def mock_finder model, return_value
    task_finder = Class.new
    stub_const(model, task_finder)
    task_finder.should_receive(:find).with(1).and_return(return_value)
  end
end
