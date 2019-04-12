accessing
sourceCode
"Return the source code of the function from the file according to the start and end line"

	| writerCode contents |
	(sourceCode isNil and: [ self file isNotNil ]) ifTrue: [ 
		contents := file asFileReference readStream contents.
		writerCode := WriteStream with: ''.
		lineStart to: lineEnd do: [ :num | 
			writerCode nextPutAll: (contents lineNumber: num);
						cr].
		sourceCode := writerCode contents. ].
	^ sourceCode