visualization
visualizeScatter

	| b ds x y |
	self scatter ifNil: [  
	b := RTGrapher new.
	b extent: 500@400.
	ds := RTData new.
	y := RTScale sqrt
    range: (Array with: 0 with: b extent y).

	x := RTScale linear
    range: (Array with: 0 with: b extent x).
	ds dotShape circle size: 8.
		"color: (self defaultColorBoxes alpha: 0.6)."
	ds points: (model values reject: [ :v | v name = '<root>']).
	ds x: [ :m | x scale: m timesExecuted ].
	ds y: [ :m | y scale: m totalMemory ].
	ds interaction popupView: self popupBlock backgroundColor: (Color lightGray alpha: 0.8).
	ds elements do: [ :e | 
		e when: TRMouseEnter do: [ movePosition := e model name.
										self logger addTime: Time now asString 
														position: self currentWorld currentHand position  
														view: self nameView 
														element: e model name 
														event: 'Over'. ].
		e when: TRMouseClick do: [ self logger addTime: Time now asString 
														position: self currentWorld currentHand position  
														view: 'Scatter'
														element: e model name 
														event: 'Click'. ].
		e when: TRMouseLeave do: [ movePosition := nil. ].  ].
	
	ds elements select: [ :el | el model isUnreachable ] thenDo: [ :el | el color: Color gray ].
	RTMetricNormalizer new
	elements: (ds elements reject: [ :el | el model isUnreachable ]);
	normalizeColor: [ :e | e size ]
	using:
		{self defaultColorBoxes .
		self colorBoxes}
	using: #sqrt.
	
	b add: ds.
	
	b axisX labelConversion: [ :n |
		n truncated ].
	b axisY labelConversion: [ :n |
		(y invert: n) round: 2 ].
	
	b axisX title: '#Executions'.
	b axisY title: 'Total Memory (MB)'.
	
	self createScatterLegend: b.
	self addAnimation: b view origin: 'Scatter'. 
	scatter := b ].

	
	^ scatter