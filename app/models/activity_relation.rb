class ActivityRelation < ActiveRecord::Base
  belongs_to :related, polymorphic: true
end
