action
updateMemory: fileName
"Given the file of memory, load the information of memory with the number line and the respective file"

	| stream line |
	stream := fileName asFileReference readStream.
	stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ | row func |
		row := line splitOn: #,.
		func := model at: (row first -> row second).
		row third = 'start' 
			ifTrue: [ func startBlocks: row fourth asNumber garbage: row fifth asNumber ]
			ifFalse: [ func endBlocks: row fourth asNumber garbage: row fifth asNumber ].
		model at: func code put: func ]