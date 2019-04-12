visualization
popupBlock
"Return the group of labels for the function"

	^  [ :g :el | |  titles |
				titles := RTGroup new.
				titles add: (((RTLabel new color: Color black) elementOn: el model name)).
				titles add: (((RTLabel new color: Color black) elementOn: '#Executions: ', el model timesExecuted asString)).
				titles add: (((RTLabel new color: Color black) elementOn: 'Memory consumed ', el model memory asString, ' kB')).
				RTVerticalLineLayout new gapSize: 0; on: titles.
				g addAll: titles
		]