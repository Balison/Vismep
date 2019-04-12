action
updateMemory: fileName
"Given the file of memory, load the information of memory with the number line and the respective file"

	| stream line |
	stream := fileName asFileReference readStream.
	stream nextLine.
	[ (line := stream nextLine) notNil ] whileTrue: 
		[ | row |
		row := line splitOn: #,.
		 model values 
			detect: [ :fun | (fun file = row second) & 
					(row third asNumber between: fun lineStart asNumber and: fun lineEnd) ]
			ifFound: [ :function | function addMemory: row fourth asNumber 
												onLine: row third asNumber.
		 									model at: function code put: function ]. ]