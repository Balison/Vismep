hooks
renderIn: aView

	| els |
	els := self createElements.
	
	self createLegend: aView.
	self normalizeElements: els.
	self createGroups: els on: aView.
	
	self createEdges: els on: aView.
	self createPopup: els.
	
	aView @ RTDraggableView @ (RTShowLabelWhenZooming new scaleThreshold: 4).
	
	self addAnimation: aView.
	
	^ aView
	