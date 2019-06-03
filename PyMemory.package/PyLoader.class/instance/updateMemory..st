action
updateMemory: fileName
"Given the file of memory, load the information of memory with the number line and the respective file"

	| stream line |
	stream := fileName asFileReference readStream.
	stream nextLine.
	[ (line := stream nextLine) notNil & 
	(line ~= 'Function,Filename,Uncollected_Start,Uncollected_End') ] whileTrue: 
		[ | row func |
		row := line splitOn: #,.
		func := model at: (row first -> row second).
		func startBlocks: row third asNumber end: row fourth asNumber.
		model at: func code put: func ].
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ | row func |
		row := line splitOn: #,.
		func := model at: (row first -> row second).
		func startUncollected: row third asNumber end: row fourth asNumber.
		model at: func code put: func ]
	