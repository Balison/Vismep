hooks
renderIn: aView

	| els |
	els := (RTBox new
		borderColor: Color veryLightGray) elementsOn: model values.
	els @ RTDraggableChildren.
	
	self normalizeElements: els.
	
	aView addAll: els.
	self createEdges: els on: aView.
	
	self createPopup: els.
	self createLegend.
	self createMenu.
	self createInteraction: els.
	
	self createLabels: els.
	RTTreeLayout new on: els.
				
	aView @ RTDraggableView @ (RTShowLabelWhenZooming new scaleThreshold: 4).
	^ aView

