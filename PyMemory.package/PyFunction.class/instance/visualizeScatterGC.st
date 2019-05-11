visualization
visualizeScatterGC

	| b ds index |
	viewGC ifNil: [  
	b := RTGrapher new.
	index := 0.
	ds := RTData new.
	ds dotShape circle
		size: 8;
		color: (self defaultColorBoxes alpha: 0.6).
	ds points: (self garbage collect: [ :v | index := index + 1.
											index -> (v value - v key) ]).
	ds x: [ :m | m key ].
	ds y: [ :m | m value ]."
	ds connectColor: Color blue."
	ds interaction popupView: [ :g :el | |  titles |
				titles := RTGroup new.
				titles add: (((RTLabel new color: Color black) elementOn: '#Execution: ', el model key asString)).
				titles add: (((RTLabel new color: Color black) elementOn: 'Uncollected objects ', el model value asString)).
				RTVerticalLineLayout new gapSize: 0; on: titles.
				g addAll: titles
		]
	 backgroundColor: (Color lightGray alpha: 0.8).
	
	b add: ds.
	
	b axisX title: '#Execution'.
	b axisY title: 'Uncollected objects'.
	^ b ].
	^ viewGC 