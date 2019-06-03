comparing
memory

	^ self blocks ifEmpty: [ ^ 0 ]
	ifNotEmpty: [   
	((self blocks collect: [ :assoc | assoc value - assoc key ]) average) asFloat round: 3 ].