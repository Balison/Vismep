visualization
loadFiles: fullName and: baseName
"Given the fullName and the baseName load the AlTrace_fileName.csv and AlMemory_fileName.csv generated"
	
	| fileName callName memoryName |
	fileName :=  baseName copyFrom: 12 to: baseName size.
	callName := fullName , '/AlTrace' , fileName , '.csv'.
	memoryName := fullName , '/AlMemory' , fileName , '.csv'.
	
	self generateModelWith: callName and: memoryName.
	^ self visualize