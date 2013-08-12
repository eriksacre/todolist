module ApplicationHelper
  def link_to_remove(object)
  	link_to "(remove)", object, method: :delete, data: {confirm: "Are you sure?"}, remote: true
  end
end
