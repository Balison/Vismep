hooks
createElements 
	| els figure functionsInvolved |
	functionsInvolved := OrderedCollection new.
	functionsInvolved addAll: (self function calledBy keys reject: [:f | f id = function id]).
	functionsInvolved add: function.
	functionsInvolved addAll: (self function callsTo keys reject: [:f | f id = function id]).
	figure := (RTBox new
		borderColor: Color veryLightGray).
	els := figure elementsOn: functionsInvolved.
	els select: [ :el | el model isLibraryFunction ] thenDo: [ :el | el trachelShape strokePaint: Color gray.
																						el trachelShape strokeWidth: 2. ].
	^ els