UI
createElements 
	| els firstEls figure |
	figure := (RTBox new
		borderColor: Color veryLightGray).
	firstEls := figure
		elementsOn: (self modelValues reject: #isLibraryFunction).
	figure borderColor: Color gray.
	figure borderWidth: 2.
	figure borderStyle solid.
	els := figure
		elementsOn: (self modelValues select: #isLibraryFunction).
	els addAll: firstEls.
	^ els