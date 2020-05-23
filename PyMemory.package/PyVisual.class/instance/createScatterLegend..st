visualization
createScatterLegend: b

	| lb |

	lb := MyLegendBuilder new.
	lb view: b view; onDemand: 'About'.
	lb addText: 'PyMemory Profiler'.
	lb addText: 'Functions are represented as circles.'.
	lb addColorFadingFrom: self defaultColorBoxes to: self colorBoxes text: 'number of lines of code'.
	lb build.