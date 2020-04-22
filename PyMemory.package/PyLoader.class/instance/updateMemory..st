action
updateMemory: fileReference
"Given the file of memory, load the information of memory with the number line and the respective file"

	| stream line |
	stream := fileReference readStream.
	stream nextLine.
	line := stream nextLine.
	[ line notNil & 
	(line ~= 'Function,Filename,Uncollected_Start,Uncollected_End') ] whileTrue: 
		[ | row func |
			[ line isEmpty ] whileTrue: [ line := stream nextLine ].
			line = 'Function,Filename,Uncollected_Start,Uncollected_End' ifFalse: [ 
			row := line splitOn: #,.
			func := model at: (row first -> row second).
			func startBlocks: row third asNumber end: row fourth asNumber.
			model at: func code put: func.
			line := stream nextLine ] ].
	line := stream nextLine.
	[ line notNil ] whileTrue: 
		[ | row func |
			[ line isNotNil and: [line isEmpty ] ] whileTrue: [ line := stream nextLine ].
			line isNil ifFalse: [ 
			row := line splitOn: #,.
			func := model at: (row first -> row second).
			func startUncollected: row third asNumber end: row fourth asNumber.
			model at: func code put: func.
			line := stream nextLine ] ]
	