tests
testSimpleRelations

	funA addCallee: funB onLine: 1.
	funB addCallee: funC onLine: 3.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funC).
	self assert: (funB isOutgoingRespectTo: funA).
	self assert: (funC isOutgoingRespectTo: funB).

