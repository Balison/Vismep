accessing
uncollected

	self garbage ifEmpty: [ ^ 0 ].
	^ (self garbage collect: [ :assoc | assoc value - assoc key ]) max