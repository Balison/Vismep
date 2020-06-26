visualization
createInteraction: els
"Add some interacion over the elements"

	els do: [ :e | 
		e when: TRMouseEnter do: [ self select: e.
										movePosition := e model name.
										self logger addTime: Time now asString 
														position: self currentWorld currentHand position  
														view: self nameView 
														element: e model name 
														event: 'Over'. ].
		e when: TRMouseClick do: [ self logger addTime: Time now asString 
														position: self currentWorld currentHand position  
														view: self nameView 
														element: e model name 
														event: 'Click'. ].
		e when: TRMouseLeave do: [ self unselect: e.
										movePosition := nil. ] ]