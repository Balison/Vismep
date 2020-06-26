initialization
write

	self filename writeStreamDo: [ :writeStream |
		(NeoCSVWriter on: writeStream)
 			writeHeader: #('Time' 'Position' 'View' 'Element' 'Event');
			nextPutAll: data;
			flush;
			close ]