action
updateMemory: fileReference
"Given the file of memory, load the information of memory with the number line and the respective file"

	| stream line |
	stream := fileReference readStream.
	"Read the headers"
	stream nextLine.
	
	[ (line := stream nextLine) notNil ] whileTrue: 
	[ | function row |
	row := line splitOn: #,..
	function := self findFunction: row first file: row second startingAt: row third asNumber.
	function ifNotNil: 
	[ function startBlocks: row fourth asNumber end: row fifth asNumber.
	model at: function id put: function. ] ]
	