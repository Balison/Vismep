hooks
initializeElement: element
	"This method is the main method called whenever the interaction is applied. It simply obtains the recursive children.
	Note that the interaction correctly handle cycles.
	
	In case the shift key is pressed, the interaction has no effect"
	
	| recursiveGetChildren dragElements |
	
	dragElements := nil.
	recursiveGetChildren := nil.
	
	recursiveGetChildren := [ :elem :ancestor|
		dragElements add: elem.
		elem outgoingEdges do: [ :edge |
			(edge to = ancestor or: [edge to = edge from ]) ifFalse: [
				recursiveGetChildren value: edge to value: ancestor].
			].
		].
	
	element when: TRMouseDragging do: [ :ev |
		| d |
		dragElements := Set new.
		ev shiftKeyPressed 
			ifTrue: [dragElements add: ev element]
			ifFalse: [recursiveGetChildren value: ev element value: ev element]. 
		ev signalUpdate.
		d := element view canvas camera distanceFromPixelToSpace: ev step.
		dragElements do: [ :e1 | e1 translateBy: d ].
		]
	