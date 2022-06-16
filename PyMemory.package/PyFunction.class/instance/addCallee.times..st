action
addCallee: aFunction times: times
"Add the function to the calls, this means this function calls to aFunction on this line"

	callsTo at: aFunction put: times.