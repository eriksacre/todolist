module ApplicationHelper
  def link_to_remove(object)
  	link_to "(remove)", object, method: :delete, data: {confirm: "Are you sure?"}, remote: true
  end
  
  def named_list(id)
    content_tag :li, id: "L#{id}" do
      yield
    end
  end
end
