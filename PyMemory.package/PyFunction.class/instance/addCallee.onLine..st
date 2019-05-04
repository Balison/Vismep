action
addCallee: aFunction onLine: line
"Add the function to the calls, this means this function calls to aFunction on this line"

	aFunction addCalledBy: self. 
	callsTo at: (aFunction -> line)
		ifPresent: [ :v | callsTo at: (aFunction -> line) put: v + 1 ]
		ifAbsent: [ callsTo at: (aFunction -> line) put: 1 ]