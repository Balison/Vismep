action
getCallee: relation
"Given a relation create or update the called function"

	^ model at: relation third -> relation sixth
		ifPresent: [ model at: (relation third  -> relation sixth ) ]
		ifAbsent: [  (PyFunction newFile: relation sixth name: relation third)
						lineStart: relation seventh asNumber; 
						lineEnd: (relation seventh asNumber + relation ninth asNumber - 1). ].