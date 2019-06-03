action
addCalledBy: aFunction times: times
"Add the function that calls this function and add the number of executions per called"

	calledBy at: aFunction put: times