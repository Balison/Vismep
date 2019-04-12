tests
testMemory

	funA lineStart: 1; lineEnd: 4.
	funB lineStart: 6; lineEnd: 8.
	funA addCallee: funB onLine: 1.
	funA addMemory: 0.45 onLine: 2.
	funA addMemory: 0.57 onLine: 3.
	funB addMemory: 0.34 onLine: 7.
	
	self assert: funA memory equals: 1.02.
	self assert: funB memory equals: 0.34.