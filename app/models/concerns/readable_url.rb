module ReadableUrl
  extend ActiveSupport::Concern
  
  def to_param
    "#{id}#{slug}"
  end
  
  private
    # Opinionated list of fields that may provide data for the slug
    SLUG_CANDIDATES = [
      'name',
      'title',
      'description',
      'content'
    ]
  
    def columns
      self.class.columns_hash
    end
  
    def slug_field
      SLUG_CANDIDATES.each do |candidate|
        return candidate if columns.has_key?(candidate) && columns[candidate].type == :string
      end
      false
    end
    
    def slug
      field = slug_field
      return "" if !field
      send(slug_field).slug
    end
end