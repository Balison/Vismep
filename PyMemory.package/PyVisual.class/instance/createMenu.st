visualization
createMenu
"Create the menu with find"
	| element viewEls aBlock myMenu |
	
	viewEls := (view elements select: [:e | e model isKindOf: PyFunction ]) sortedAs: [:a :b | a model name < b model name].
	aBlock := [ element := UIManager default 
		chooseFrom: (viewEls select: [ :e | e model isKindOf: PyFunction ] 
							thenCollect: [:e | e model name])
		values: viewEls.
		element notNil
			ifTrue: [ view canvas camera translateTo: element position. RTBlink on: element ] ].
		
	myMenu := RTPythonMenu new view: view.
	myMenu menu: 'Find' background: ((Color fromHexString: '263238') alpha: 0.6) highlightColor: Color blue callback: [ 
		aBlock value. ].
	