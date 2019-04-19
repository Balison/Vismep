visualization
createLegend: aView
"Create a legend for the callgraph"

	| lb |
	lb := MyLegendBuilder new.
	lb view: aView view; onDemand: 'About'.
	lb addText: 'This is a subgraph of calls related to the function ' , function name.
	lb addColor: Color red text: 'Functions calling to ', function name.
	lb addColor: Color black text: function name.
	lb addColor: Color blue text: 'Functions called by ' , function name.
	"lb addText: 'The middle box represent the function ' , function name.
	lb addText: 'The left box contains the functions calling to ' , function name.
	lb addText: 'The right box contains the functions calleb by ' , function name."
	lb addRectanglePolymetricWidth: 'Memory consumed' height: '# Executions' box: 'a Python function'.
	lb addColorFadingFrom: self defaultColorBoxes to: self colorBoxes text: 'number of lines of code'.
	lb build.
	^ lb