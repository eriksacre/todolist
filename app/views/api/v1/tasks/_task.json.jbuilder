json.(task, :id, :title)
json.position task.position if task.position
json.completed task.completed ? true : false
json.url api_v1_task_url(task)
