Feature Tasks api

	Scenario: Retrieve all tasks
		Given I am a valid API user
		And I send and accept JSON
		And I have following tasks:
		  | 1 | First task | false | 0 |
		  | 2 | Second task | false | 1 |
		  | 3 | Third task | true | nil |
		When I send a GET request for "/api/v1/tasks"
		Then the response should be 200
		# And the JSON response should be:
		