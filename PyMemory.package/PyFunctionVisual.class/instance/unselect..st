visualization
unselect: anElement
"Return the element to his original form if it's different of the self function represented"

	anElement model = function ifFalse: [ 
		self unhighlightNode: anElement. ].
		(self incomingEdgesOf: anElement) do: [ :anEdge |
			anEdge trachelShape allColor: self defaultColorEdges.
		].
		(self outgoingEdgesOf: anElement) do: [ :anEdge |
			anEdge trachelShape allColor: self defaultColorEdges.
		].