tests
testSimpleCallsTo

	funA addCallee: funB times: 1.
	funB addCallee: funC times: 1.
	
	self assert: funA calledBy isEmpty.
	self assert: funC callsTo isEmpty.
	self assert: funA callsTo size equals: 1.
	self assert: funB callsTo size equals: 1.

