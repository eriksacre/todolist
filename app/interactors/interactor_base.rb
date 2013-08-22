class InteractorBase
  def self.dependencies *args
    args.each do |dependency|
      define_method("#{dependency}=".to_sym) do |value|
        instance_variable_set("@#{dependency}", value)
      end
      
      define_method("#{dependency}".to_sym) do
        value = instance_variable_get("@#{dependency}")
        return dependency.camelize.constantize if !value
        value
      end
    end
  end
end
