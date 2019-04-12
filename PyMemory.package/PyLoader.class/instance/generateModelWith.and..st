action
generateModelWith: callFile and: memoryFile
"Given the trace file and the memory file generate a model"
	
	self loadCall: callFile.
	self updateMemory: memoryFile.
			