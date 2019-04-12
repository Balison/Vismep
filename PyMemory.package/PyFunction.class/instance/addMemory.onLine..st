action
addMemory: amount onLine: aLine
"Increment the memory and save the lines per memory"

	self addMemory: amount.
	memoryLines at: (aLine - lineStart + 1)
		ifPresent: [ :old |
			| newAmount |
			newAmount := old + amount.
			memoryLines at: (aLine - lineStart + 1) put: newAmount  ]
		ifAbsent: [ memoryLines at: (aLine - lineStart + 1) put: amount ]
		
	