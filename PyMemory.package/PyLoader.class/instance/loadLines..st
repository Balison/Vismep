action
loadLines: fileName
"Given the name of file, update the hot lines of memory."

	| stream line row |
	stream := fileName asFileReference readStream.
	stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ row := line splitOn: #,.
		model at: row first -> row second 
			ifPresent: [ :fun | fun addLine: row third asNumber with: row fourth asNumber executed: row fifth asNumber ]
		].