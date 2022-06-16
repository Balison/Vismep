as yet unclassified
loadFunctions: fileReference
"Given the reference of file,  create a PyFunction."

	| stream line count|
	stream := fileReference readStream.
	"Read headers"
	line := stream nextLine.
	count := 1.
	
	[ (line := stream nextLine) notNil ] whileTrue: 
	[ | function |
		function := self createFunction: line with: count. 
		model at: function id put: function.
		count := count + 1 ].