tests
testSimpleRelations

	funA addCallee: funB times: 1.
	funB addCalledBy: funA times: 1.
	funB addCallee: funC times: 1.
	funC addCalledBy: funB times: 1.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funC).
	self assert: (funB isOutgoingRespectTo: funA).
	self assert: (funC isOutgoingRespectTo: funB).

