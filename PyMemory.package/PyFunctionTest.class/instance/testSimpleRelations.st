tests
testSimpleRelations

	funA addCallee: funB onLine: 1 times: 1.
	funB addCalledBy: funA times: 1.
	funB addCallee: funC onLine: 3 times: 1.
	funC addCalledBy: funB times: 1.
	
	self assert: (funA isIncomingRespectTo: funB).
	self assert: (funB isIncomingRespectTo: funC).
	self assert: (funB isOutgoingRespectTo: funA).
	self assert: (funC isOutgoingRespectTo: funB).

