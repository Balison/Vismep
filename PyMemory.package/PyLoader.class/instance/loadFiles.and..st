visualization
loadFiles: fullName and: baseName
"Given the fullName and the baseName load the AlTrace_fileName.csv and AlMemory_fileName.csv generated"
	
	| fileName callName memoryName linesName |
	fileName :=  baseName copyFrom: 12 to: baseName size.
	callName := fullName , '/AlTrace_' , fileName , '.csv'.
	memoryName := fullName , '/AlMemory_' , fileName , '.csv'.
	linesName := fullName , '/AlLines_' , fileName , '.csv'.
	
	self generateModelWith: (Array with: callName with: memoryName with: linesName).
	^ self visualize