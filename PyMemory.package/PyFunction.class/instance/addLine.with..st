action
addLine: number with: memory
"Update the lines that consumes memory on the function"

	(number - lineStart + 1) positive ifTrue: [ memoryLines at: (number - lineStart + 1) put: memory ]
	