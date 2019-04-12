visualization
incomingEdgesOf: anElement
"Return the edges that are incoming"

	^ anElement connectedEdges select: [ :edge | edge to == anElement ]