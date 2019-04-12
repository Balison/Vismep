action
addCallee: aFunction onLine: line
"Add the function to the calls, this means this function calls to aFunction on this line"

	aFunction addCalledBy: self. 
	callsTo add: (aFunction -> line)