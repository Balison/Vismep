action
loadCall: fileName
"Given the name of file, create two PyFunction by call with all the information, if a PyFunction is already created we only modify their callers or callees."

	| stream line relation index |
	stream := fileName asFileReference readStream.
	stream nextLine.
	index := 1.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ | caller callee | 
		relation := line splitOn: #,.
		
		(self continueLoad: relation on: index)
			ifTrue: [  
				caller := self getCaller: relation on: index.
				callee := self getCallee: relation.
				caller addCallee: callee onLine: relation fifth asNumber.
				model at: caller code put: caller.
				model at: callee code put: callee.
				index := index + 1 ]].