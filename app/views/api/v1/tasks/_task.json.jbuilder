json.(task, :id, :title)
json.position task.position if task.position
json.completed task.completed ? true : false
json.completed_at task.completed_at.to_formatted_s(:iso8601) if task.completed
json.url api_v1_task_url(task)
