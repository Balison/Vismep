visualization
createMenu
"Create the menu with find"
	| element viewEls |
	
	viewEls := (view elements select: [:e | e model isKindOf: PyFunction ]) sortedAs: [:a :b | a model name < b model name].
	view addMenu: 'Find' callback: [  
		element := UIManager default 
		chooseFrom: (viewEls select: [ :e | e model isKindOf: PyFunction ] 
							thenCollect: [:e | e model name])
		values: viewEls.
		element notNil
			ifTrue: [ view canvas camera translateTo: element position. RTBlink on: element ] ].