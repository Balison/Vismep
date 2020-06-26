visualization
visualizeScatter

	| b ds x y |
	self scatter ifNil: [  
	b := RTGrapher new.
	b extent: 500@400.
	ds := RTData new.
	y := RTScale log
    range: (Array with: 0 with: b extent y).

	x := RTScale linear
    range: (Array with: 0 with: b extent x).
	ds dotShape circle size: 8.
		"color: (self defaultColorBoxes alpha: 0.6)."
	ds points: (model values reject: [ :v | v name = '<root>']).
	ds x: [ :m | m timesExecuted ].
	ds y: [ :m | y scale: (m memory + 1) ].
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
	RTMetricNormalizer new
	elements: ds elements;
	normalizeColor: [ :e | e size ]
	using:
		{self defaultColorBoxes .
		self colorBoxes}
	using: #sqrt.
	
	b add: ds.
	
	b axisX labelConversion: [ :n |
		n truncated ].
	b axisY labelConversion: [ :n |
		((y invert: n) - 1) round: 2 ].
	
	b axisX title: '#Executions'.
	b axisY title: 'Memory (kB)'.
	
	self createScatterLegend: b.
	self addAnimation: b view origin: 'Scatter'. 
	scatter := b ].

	
	^ scatter