accessing
uncollected

	^ (self garbage collect: [ :assoc | assoc value - assoc key ]) average