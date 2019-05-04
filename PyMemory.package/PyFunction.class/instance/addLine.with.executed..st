action
addLine: number with: memory executed: times
"Update the lines that consumes memory on the function"

	memoryLines at: (number - lineStart + 1) put: memory 
	