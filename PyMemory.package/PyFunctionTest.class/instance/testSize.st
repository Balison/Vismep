tests
testSize

	funA lineStart: 1; lineEnd: 4.
	funB lineStart: 6; lineEnd: 8.
	funA addCallee: funB onLine: 1 times: 1.
	
	self assert: funA size equals: 4.
	self assert: funB size equals: 3.