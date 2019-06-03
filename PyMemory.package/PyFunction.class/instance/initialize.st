initialization
initialize 

	super initialize.
	calledBy := Dictionary new.
	callsTo := Dictionary new.
	blocks := OrderedCollection new.
	uncollected := OrderedCollection new.
	memoryLines := Dictionary new.