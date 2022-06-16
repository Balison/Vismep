visualization
createLegend
"Create a legend for the callgraph"

	| lb |
	lb := MyLegendBuilder new.
	lb view: view view; onDemand: 'About'.
	lb addText: 'Vismep'.
	lb addText: 'Black border line for functions of external libraries.'.
	lb addRectanglePolymetricWidth: 'Memory consumed' height: '# Executions' box: 'a Python function'.
	lb addColorFadingFrom: self defaultColorBoxes to: self colorBoxes text: 'number of lines of code'.
	lb build.
	^ lb