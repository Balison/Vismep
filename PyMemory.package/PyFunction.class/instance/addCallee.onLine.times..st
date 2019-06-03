action
addCallee: aFunction onLine: line times: times
"Add the function to the calls, this means this function calls to aFunction on this line"

	callsTo at: (aFunction -> line) put: times.