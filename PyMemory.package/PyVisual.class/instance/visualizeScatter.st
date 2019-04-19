visualization
visualizeScatter

	| b ds |
	b := RTGrapher new.
	b extent: 500@400.
	ds := RTData new.
	"y := RTScale log
		base: Float e;
    domain: (#(0 9) collect: #exp);
    range: (Array with: 0 with: b extent y).

	x := RTScale log
		base: Float e;
    domain: (#(0 9) collect: #exp);
    range: (Array with: 0 with: b extent x)."
	ds dotShape circle
		size: 8;
		color: (self defaultColorBoxes alpha: 0.6).
	ds points: (model values reject: [ :v | v name = '<root>']).
	ds x: [ :m | m timesExecuted ].
	ds y: [ :m | m memory ].
	ds interaction popupView: self popupBlock backgroundColor: (Color lightGray alpha: 0.8).
	
	b add: ds.
	
	b axisX title: '#Executions'.
	b axisY title: 'Memory'.
	^ b