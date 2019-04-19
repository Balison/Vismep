accessing
sourceCode
"Return the source code of the function from the file according to the start and end line"

	| writerCode contents |
	(sourceCode isNil and: [ self file isNotNil ]) ifTrue: [ 
		writerCode := WriteStream with: ''.
		file asFileReference exists 
		ifTrue: [ 
			contents := file asFileReference readStream contents.
			lineStart to: lineEnd do: [ :num | 
			writerCode nextPutAll: (contents lineNumber: num);
						cr]. ]
		ifFalse: [ writerCode nextPutAll: 'I cant load the file! The folder is missed' ].
		sourceCode := writerCode contents. ].
	^ sourceCode