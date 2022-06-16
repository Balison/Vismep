comparing
totalMemory

	^ self blocks ifEmpty: [ ^ 0 ]
	ifNotEmpty: [   
	((self blocks collect: [ :assoc | assoc value - assoc key ]) sum) asFloat round: 3 ].