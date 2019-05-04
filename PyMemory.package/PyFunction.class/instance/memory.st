comparing
memory

	^ ((self blocks collect: [ :assoc | assoc value - assoc key ]) average) asFloat round: 2