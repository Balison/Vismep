visualization
createInteraction: els
"Add some interacion over the elements"

	els do: [ :e | 
		e when: TRMouseEnter do: [ self select: e. ].
		e when: TRMouseLeave do: [ self unselect: e ].  ]