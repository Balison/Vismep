visualization
visualizeScatter

	| b ds |
	b := RTGrapher new.
	b extent: 300 @ 300.
	ds := RTData new.
	ds dotShape circle
	size: 8;
	color: (self defaultColorBoxes alpha: 0.6).
	ds points: (model values reject: [ :v | v name = '<root>']).
	ds x: #timesExecuted.
	ds y: [ :m | m memory ].
	ds interaction popupView: self popupBlock backgroundColor: (Color lightGray alpha: 0.8).
	
	b add: ds.
	b axisX title: '#Executions'.
	b axisY title: 'Memory'.
	^ b