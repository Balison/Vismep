visualization
createMenu
"Create the menu with find"
	| element |
	
	view addMenu: 'Find' callback: [  
		element := UIManager default 
		chooseFrom: (view elements select: [ :e | e model isKindOf: PyFunction ] 
							thenCollect: [:e | e model name]) 
		values: view elements.
		element notNil
			ifTrue: [ view canvas camera translateTo: element position. RTBlink on: element ] ].