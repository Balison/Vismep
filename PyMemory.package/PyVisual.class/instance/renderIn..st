hooks
renderIn: aView

	| els |
	els := (RTBox new
		borderColor: Color veryLightGray) elementsOn: model values.
	els @ RTDraggable.
	
	self normalizeElements: els.
	
	aView addAll: els.
	self createEdges: els on: aView.
	
	RTTreeLayout on: els.
	self createPopup: els.
	self createLegend.
	self createMenu.
	self createInteraction: els.
	
	self createLabels: els.
				
	aView @ RTDraggableView @ RTShowLabelWhenZooming.
	^ aView

