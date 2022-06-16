action
loadCall: fileReference
"Given the reference of file,  create a call between the functions involved."

	| stream line |
	stream := fileReference readStream.
	"Read headers"
	line := stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
	[ | caller callee row |
		row := line splitOn: #,..
		caller := self findFunction: row first file: row second startingAt: row third asNumber.
		callee := self findFunction: row fourth file: row fifth startingAt: row sixth asNumber.
		caller isNotNil & callee isNotNil ifTrue: 
		[ caller addCallee: callee times: row seventh asNumber.
		callee addCalledBy: caller times: row seventh asNumber.
		
		model at: caller id put: caller.
		model at: callee id put: callee. ]
	].