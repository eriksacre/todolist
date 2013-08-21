require 'ostruct'

class DataObject < OpenStruct
  def initialize *fields
    super *fields
  end
  
  def save!
    self.has_saved = true
    saver.call if saver
  end
  
  attr_writer :saver
end

