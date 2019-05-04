action
generateModelWith: aArray
"Given the trace file and the memory file generate a model"
	
	self loadCall: (aArray at: 1).
	self updateMemory: (aArray at: 2).
	self loadLines: (aArray at: 3)
			