hooks
createElements 
	| els figure functionsInvolved |
	functionsInvolved := OrderedCollection new.
	functionsInvolved addAll: self function calledBy keys.
	functionsInvolved add: function.
	functionsInvolved addAll: self function callsTo keys.
	figure := (RTBox new
		borderColor: Color veryLightGray).
	els := figure elementsOn: functionsInvolved.
	els select: [ :el | el model isLibraryFunction ] thenDo: [ :el | el trachelShape strokePaint: Color gray.
																						el trachelShape strokeWidth: 2. ].
	^ els