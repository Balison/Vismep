UI
createElements 
	| els figure |
	figure := (RTBox new
		borderColor: Color veryLightGray).
	els := figure elementsOn: self modelValues.
	els select: [ :el | el model isLibraryFunction ] thenDo: [ :el | el trachelShape strokePaint: Color gray.
																						el trachelShape strokeWidth: 2. ].
	^ els