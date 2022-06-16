action
loadLines: fileReference
"Given the reference of file, update the hot lines of memory. 'Function','Filename','Line_Start','Line','Memory'"

	| stream line row |
	stream := fileReference readStream.
	"Read headers"
	stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ | function |
		row := line splitOn: #,..
		function := self findFunction: row first file: row second  startingAt: row third asNumber.
		function ifNotNil: 
		[ function addLine: row fourth asNumber with: row fifth asNumber.
		model at: function id put: function ] ].