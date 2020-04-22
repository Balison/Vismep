action
loadLines: fileReference
"Given the reference of file, update the hot lines of memory."

	| stream line row |
	stream := fileReference readStream.
	stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ [ line isNotNil and: [ line isEmpty ] ] whileTrue: [ line := stream nextLine ].
		line isNil ifFalse: [  
			row := line splitOn: #,.
			model at: row first -> row second 
				ifPresent: [ :fun | fun addLine: row third asNumber with: row fourth asNumber executed: row fifth asNumber ]]].