tests
testSelfRelations

	funA addCallee: funB onLine: 1.
	funB addCallee: funB onLine: 2.
	funB addCallee: funB onLine: 2.
	funB addCallee: funB onLine: 2.
	funB addCallee: funC onLine: 3.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funB).
	self assert: (funB isOutgoingRespectTo: funB).
	self assert: (funC isOutgoingRespectTo: funB).

