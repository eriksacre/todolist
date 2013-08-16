json.array! @tasks do |json, task|
  json.partial! task
end
