initialization
initialize 

	super initialize.
	calledBy := Dictionary new.
	callsTo := Dictionary new.
	blocks := OrderedCollection new.
	memoryLines := Dictionary new.