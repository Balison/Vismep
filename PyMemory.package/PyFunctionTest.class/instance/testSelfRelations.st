tests
testSelfRelations

	funA addCallee: funB times: 1.
	funB addCallee: funB times: 3.
	funB addCalledBy: funA times: 1.
	funB addCalledBy: funB times: 3.
	funB addCallee: funC times: 1.
	funC addCalledBy: funB times: 1.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funB).
	self assert: (funB isOutgoingRespectTo: funB).
	self assert: (funC isOutgoingRespectTo: funB).

