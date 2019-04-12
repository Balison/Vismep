enumerating
select: anElement
"Add the interactions for a selected element"

	self highlightNode: anElement.
	(self incomingEdgesOf: anElement) do: [ :anEdge |
		anEdge trachelShape allColor: self incomingArrowColor.
	].
	(self outgoingEdgesOf: anElement) do: [ :anEdge |
		anEdge trachelShape allColor: self outgoingArrowColor.
	].