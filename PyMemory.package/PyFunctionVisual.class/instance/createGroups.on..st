hooks
createGroups: els on: aView
"Create groups of elements according to: incoming myself outgoing"

	| es |
	self incoming: (els select: [ :e | (e model isIncomingRespectTo: function) & ((e model isOutgoingRespectTo: function) not)& (e model ~= function) ]).
	self outgoing: (els select: [ :e | (e model isOutgoingRespectTo: function) & (e model ~= function) ]).
	self myself: (els select: [ :e | e model = function ]).
	self highlightNode: myself elements first.
	
	
	es := RTBox elementsOn: {#incoming .#myself. #outgoing}.

	es first trachelShape strokePaint: Color red.
	es second trachelShape strokePaint: Color black.
	es third trachelShape strokePaint: Color blue.
	aView add: es.
	es @ RTDraggable.
	RTNest new
	for: es
	add: [ :group :amodel | 
		group addAll: (self perform: amodel).
		RTVerticalLineLayout on: group.
	].
	
	RTHorizontalLineLayout on: es.
	self createLabels: (es collect: #nestedElements).
	self createInteraction: (es flatCollect: #nestedElements).
			
	
	