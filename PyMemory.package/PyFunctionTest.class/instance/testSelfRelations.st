tests
testSelfRelations

	funA addCallee: funB onLine: 1 times: 1.
	funB addCallee: funB onLine: 2 times: 3.
	funB addCalledBy: funA times: 1.
	funB addCalledBy: funB times: 3.
	funB addCallee: funC onLine: 3 times: 1.
	funC addCalledBy: funB times: 1.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funB).
	self assert: (funB isOutgoingRespectTo: funB).
	self assert: (funC isOutgoingRespectTo: funB).

