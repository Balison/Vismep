visualization
visualizeScatter

	| b ds x y |
	b := RTGrapher new.
	b extent: 500@400.
	ds := RTData new.
	y := RTScale log
    range: (Array with: 0 with: b extent y).

	x := RTScale log
    range: (Array with: 0 with: b extent x).
	ds dotShape circle size: 8.
		"color: (self defaultColorBoxes alpha: 0.6)."
	ds points: (model values reject: [ :v | v name = '<root>']).
	ds x: [ :m | x scale: (m timesExecuted + 1) ].
	ds y: [ :m | y scale: (m memory + 1) ].
	ds interaction popupView: self popupBlock backgroundColor: (Color lightGray alpha: 0.8).
	RTMetricNormalizer new
	elements: ds elements;
	normalizeColor: [ :e | e size ]
	using:
		{self defaultColorBoxes .
		self colorBoxes}
	using: #sqrt.
	
	b add: ds.
	
	b axisX labelConversion: [ :n |
		((x invert: n) - 1) truncated ].
	
	b axisY labelConversion: [ :n |
		((y invert: n) - 1) round: 2 ].
	
	b axisX title: '#Executions'.
	b axisY title: 'Memory (kB)'.
	
	self createScatterLegend: b.
	
	^ b