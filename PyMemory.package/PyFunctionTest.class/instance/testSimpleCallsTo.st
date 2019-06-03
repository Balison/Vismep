tests
testSimpleCallsTo

	funA addCallee: funB onLine: 1 times: 1.
	funB addCallee: funC onLine: 3 times: 1.
	
	self assert: funA calledBy isEmpty.
	self assert: funC callsTo isEmpty.
	self assert: funA callsTo size equals: 1.
	self assert: funB callsTo size equals: 1.

