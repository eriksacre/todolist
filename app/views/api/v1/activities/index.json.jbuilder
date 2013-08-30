json.array! @activities do |activity|

	json.id activity.id

	json.user do
		json.id activity.user.id
		json.email activity.user.email
	end
	
	json.recorded_at activity.recorded_at.to_formatted_s(:iso8601)

	exhibit = ActivityExhibit.new(activity, self)
	json.action exhibit.action_text
	
	json.subject do
		json.title exhibit.title
		json.url exhibit.api_url
	end

end
