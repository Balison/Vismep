hooks
renderIn: aView

	| els |
	els := self createElements.
	els @ PyDraggableChildren.
	
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
	self addAnimation: aView.
	
	^ aView

