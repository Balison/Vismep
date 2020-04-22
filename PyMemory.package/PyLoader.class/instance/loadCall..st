action
loadCall: fileReference
"Given the reference of file, create two PyFunction by call with all the information, if a PyFunction is already created we only modify their callers or callees."

	| stream line relation fun |
	stream := fileReference readStream.
	line := stream nextLine.
	[ line notNil and: [ line isNotEmpty &
	(line = 'IdThread,Function,Filename,Line_Start,Size,Times') ] ] whileTrue: 
	[ | caller callee |
		line := stream nextLine.
		[ line isEmpty ] whileTrue:
			[ line := stream nextLine ].
		fun := self readFirstHeader: line. 
		model at: fun code put: fun.
	
		[ line = 'Calls_to,Filename,Line,Times' ] whileFalse: [ line := stream nextLine ].	
		line := stream nextLine.
		[ line notNil & (line ~= 'Called_by,Filename,Times') ] whileTrue: 
		[ 	[ line isEmpty ] 
				whileTrue: [ line := stream nextLine ].
			line = 'Called_by,Filename,Times' ifFalse: [ 
				relation := line splitOn: #,.
				caller := self readSecondHeader: relation.
				fun addCallee: caller onLine: relation third asNumber times: relation fourth asNumber.
				model at: caller code put: caller. 
				line := stream nextLine ] ].
		
		[ line = 'Called_by,Filename,Times' ] whileFalse: [ line := stream nextLine ].
		line := stream nextLine.
		[ line notNil &
		(line ~= 'IdThread,Function,Filename,Line_Start,Size,Times') ] whileTrue: 
		[	[ line isNotNil and: [ line isEmpty ] ] whileTrue: [ line := stream nextLine  ].
			(line isNil or: 
			[line = 'IdThread,Function,Filename,Line_Start,Size,Times']) ifFalse: [ 
			relation := line splitOn: #,.  
			callee := self readThirdHeader: relation.
			fun addCalledBy: callee times: relation third asNumber.
			model at: callee code put: callee.
			line := stream nextLine ] ]. 
		"line := stream nextLine" ]