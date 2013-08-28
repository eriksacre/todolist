class Exhibit < SimpleDelegator
  @@exhibits = []
  
  def initialize(model, context)
    @context = context
    super(model)
  end
  
  def self.exhibits
    # @@exhibits
    [
      IncompleteTaskExhibit,
      CompleteTaskExhibit,
      TaskListExhibit,
      ActivitiesExhibit,
      ActivityExhibit,
      EnumerableExhibit
    ]
  end
  
  def self.inherited(child)
    @@exhibits << child
  end
  
  def self.exhibit(object, context=nil)
    return object if exhibited_object?(object)
    exhibits.inject(object) do |object, exhibit|
      exhibit.exhibit_if_applicable(object, context)
    end
  end
  
  def self.exhibit_if_applicable(object, context)
    if applicable_to?(object)
      new(object, context)
    else
      object
    end
  end
  
  def self.applicable_to?(object)
    false
  end
  
  def self.exhibited_object?(object)
    object.respond_to?(:exhibited?) && object.exhibited?
  end
  
  def self.exhibit_query(*method_names)
    method_names.each do |name|
      define_method(name) do |*args, &block|
        exhibit(super(*args, &block))
      end
    end
  end
  private_class_method :exhibit_query
  
  def self.object_is_any_of?(object, *classes)
    # What with Rails development mode reloading making class matching
    # unreliable, plus wanting to avoid adding dependencies to
    # external class definitions if we can avoid it, we just match
    # against class/module name strings rather than the actual class
    # objects.
    # Note that '&' is the set intersection operator for Arrays. 
    (classes.map(&:to_s) & object.class.ancestors.map(&:name)).any?
  end
  private_class_method :object_is_any_of?
  
  def self.find_definitions(definition_file_paths)
    absolute_definition_file_paths = definition_file_paths.map {|path| File.expand_path(path) }

    absolute_definition_file_paths.uniq.each do |path|
      load("#{path}.rb") if File.exists?("#{path}.rb")

      if File.directory? path
        Dir[File.join(path, '**', '*.rb')].sort.each do |file|
          load file if !file.end_with?("/exhibit.rb")
        end
      end
    end
  end
    
  def exhibit(model)
    Exhibit.exhibit(model, @context)
  end
      
  def render(template)
    template.render(:partial => to_partial_path, :object => self)
  end
    
  def to_partial_path
    if __getobj__.respond_to?(:to_partial_path)
      __getobj__.to_partial_path
    else
      partialize_name(__getobj__.class.name)
    end
  end  
  
  def to_model
    __getobj__
  end
  
  def class
    __getobj__.class
  end

  def kind_of?(klass)
    __getobj__.kind_of?(klass)
  end
  
  def instance_of?(klass)
    __getobj__.instance_of?(klass)
  end
  
  # def is_a?(klass)
  #   __getobj__.is_a?(klass)
  # end
  
  def exhibited?
    true
  end
  
  private
    def partialize_name(name)
      "/#{name.underscore.pluralize}/#{name.demodulize.underscore}"
    end  
end