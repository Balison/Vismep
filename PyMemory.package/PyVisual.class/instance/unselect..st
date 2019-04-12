visualization
unselect: anElement

	self unhighlightNode: anElement.
	(self incomingEdgesOf: anElement) do: [ :anEdge |
		anEdge trachelShape allColor: self defaultColorEdges.
	].
	(self outgoingEdgesOf: anElement) do: [ :anEdge |
		anEdge trachelShape allColor: self defaultColorEdges.
	].