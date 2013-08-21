require 'data_object'

module ActiveRecordMock
  def mock_finder model, return_value
    mock_model(model).should_receive(:find).with(1).and_return(return_value)
  end
  
  def mock_model model
    @@models ||= {}
    @@models[model] = Object.const_set(model, Class.new(DataObject)) if @@models[model].nil?
    @@models[model]
  end
end
