#!/bin/bash

echo "Testing the Tasks api using curl"

echo "1. Get all tasks"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' http://todolist.dev/api/v1/tasks
echo
echo

echo "2. Create a resource"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X POST -d '{ "title": "API generated task" }' http://todolist.dev/api/v1/tasks
echo
echo


echo "3. Get a single resource"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' http://todolist.dev/api/v1/tasks/$1
echo
echo


echo "4. Change the title of a single task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "title": "API modified task" }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "5. Delete a task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X DELETE http://todolist.dev/api/v1/tasks/$1
echo
echo

echo "6. Create a resource with validation error"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X POST -d '{ "titlex": "API generated task" }' http://todolist.dev/api/v1/tasks
echo
echo

