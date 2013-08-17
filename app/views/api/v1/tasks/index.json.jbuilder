json.todo @tasks.todo do |task|
  json.partial! task
end
json.completed @tasks.completed do |task|
  json.partial! task
end