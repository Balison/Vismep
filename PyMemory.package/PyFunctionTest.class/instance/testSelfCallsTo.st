tests
testSelfCallsTo

	funA addCallee: funB onLine: 1.
	funB addCallee: funB onLine: 2.
	funB addCallee: funB onLine: 2.
	funB addCallee: funB onLine: 2.
	funB addCallee: funC onLine: 3.
	
	self assert: funA calledBy isEmpty.
	self assert: funC callsTo isEmpty.
	self assert: funA callsTo size equals: 1.
	self assert: funB callsTo size equals: 2.
	self assert: (funB callsTo includes: funB->2).
	self assert: (funB callsTo includes: funC->3).
	self assert: (funB calledBy keys includes: funB).
	self assert: (funB calledBy keys includes: funA).
	self assert: funB timesExecuted equals: 4.

