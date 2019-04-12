action
addCalledBy: aFunction
"Add the function that calls this function and add the number of executions per called"

	calledBy at: aFunction
				ifPresent: [ :exe | calledBy at: aFunction put: exe + 1 ]
				ifAbsent: [ calledBy at: aFunction put: 1 ].