action
loadCall: fileName
"Given the name of file, create two PyFunction by call with all the information, if a PyFunction is already created we only modify their callers or callees."

	| stream line relation fun |
	stream := fileName asFileReference readStream.
	line := stream nextLine.
	[ line notNil & 
	(line = 'IdThread,Function,Filename,Line_Start,Size,Times') ] whileTrue: 
	[  | caller callee |
		line := stream nextLine.
		relation := line splitOn: #,.
		fun := model at: relation second -> relation third 
		ifPresent: [ (model at: relation second -> relation third) ]
		ifAbsent: [ (PyFunction newFile: relation third 
								name: relation second) ].
							
		fun thread: relation first asNumber;
			lineStart: relation fourth asNumber; 
			lineEnd: (relation fourth asNumber + relation fifth asNumber - 1);
			timesExecuted: relation sixth asNumber.
	
		model at: fun code put: fun.
		
		line := stream nextLine.
		[ (line := stream nextLine) notNil &
		(line ~= 'Called_by,Filename,Times') ] whileTrue: 
		[ 
			relation := line splitOn: #,.
		
			caller := model at: relation first -> relation second
				ifPresent: [ model at: relation first -> relation second ]
				ifAbsent: [ PyFunction newFile: relation second name: relation first ].
		
			fun addCallee: caller onLine: relation third asNumber times: relation fourth asNumber.
			model at: caller code put: caller. ].
		
		
		[ (line := stream nextLine) notNil & 
		(line ~= 'IdThread,Function,Filename,Line_Start,Size,Times') ] whileTrue: 
		[ 
			relation := line splitOn: #,.
		
			callee := model at: relation first -> relation second
				ifPresent: [ model at: relation first -> relation second ]
				ifAbsent: [ PyFunction newFile: relation second name: relation first ].
		
			fun addCalledBy: callee times: relation third asNumber.
			model at: callee code put: callee. ]

	]