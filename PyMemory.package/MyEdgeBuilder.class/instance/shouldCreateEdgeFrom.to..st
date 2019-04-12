testing
shouldCreateEdgeFrom: fromElement to: toElement
	"Return true if an edge has to be created"
	super shape: originalShape.
	fromElement == toElement ifTrue: [ super shape: self selfShape.
		^ true ].
	(fromElement isNil or: [ toElement isNil ]) ifTrue: [ ^ false ].
	allowRepetition ifFalse: [ ^ fromElement outgoingEdges noneSatisfy: [ :edge | edge to == toElement ] ].
	^ true