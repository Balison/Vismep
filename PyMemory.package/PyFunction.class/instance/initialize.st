initialization
initialize 

	super initialize.
	calledBy := Dictionary new.
	callsTo := Set new.
	memory := 0.
	memoryLines := Dictionary new.