comparing
memory

	^ self blocks ifEmpty: [ ^ 0 ]
	ifNotEmpty: [   
	((self blocks collect: [ :assoc | (assoc value - assoc key) < 0 ifTrue: [ 0 ] ifFalse: [ (assoc value - assoc key) ] ]) average) asFloat round: 3 ].