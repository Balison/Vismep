visualization
outgoingEdgesOf: anElement
"Return the outgoing edges of a element"

	^ anElement connectedEdges select: [ :edge | edge from == anElement ]