module SubjectHelper
  private
    def find_subject *klasses
      klass = klasses.detect {|c| class_id(c) }
      @subject = klass ? klass.find(class_id(klass).to_i) : nil
    end
  
    def class_id klass
      params["#{klass.name.underscore}_id"]
    end
end
