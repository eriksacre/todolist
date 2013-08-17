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

echo "4b. Change the position of a task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "position": 3 }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4c. Complete a task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "completed": true }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4c2. Complete a task that is already completed"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "completed": true }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4c3. Change the position of a completed task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "position": 3 }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4d. Reopen a task"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "completed": false }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4d2. Reopen a task that is already open"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "completed": false }' http://todolist.dev/api/v1/tasks/$1
echo
echo
echo

echo "4e. Invalid field combo"
curl -w "%{http_code}" -u "47uP4wQ-356qpg0VegikVA:x" -H 'Content-Type: application/json' -X PUT -d '{ "completed": true, "position": 8 }' http://todolist.dev/api/v1/tasks/$1
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

echo "7. Find the API token for a given user, using the special me-resource"
curl -w "%{http_code}" -u "erik.sacre@gmail.com:ok" -H 'Content-Type: application/json' http://todolist.dev/api/v1/me
echo
echo

echo "7b. Find the API token for a given user, using the special me-resource, but passing a wrong email"
curl -w "%{http_code}" -u "erik.sacred@gmail.com:ok" -H 'Content-Type: application/json' http://todolist.dev/api/v1/me
echo
echo

echo "7c. Find the API token for a given user, using the special me-resource, but passing a wrong password"
curl -w "%{http_code}" -u "erik.sacre@gmail.com:nok" -H 'Content-Type: application/json' http://todolist.dev/api/v1/me
echo
echo

