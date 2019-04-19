hooks
renderIn: aView

	| els |
	els := (RTBox new
		borderColor: Color veryLightGray) elementsOn: model values.
	
	self createLegend: aView.
	self normalizeElements: els.
	self createGroups: els on: aView.
	
	self createEdges: els on: aView.
	self createPopup: els.
	
	aView @ RTDraggableView @ (RTShowLabelWhenZooming new scaleThreshold: 4).
	
	^ aView
	