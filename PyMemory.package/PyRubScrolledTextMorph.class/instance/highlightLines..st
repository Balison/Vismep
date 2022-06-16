accessing
highlightLines: aCollection

	| max |
	max := aCollection ifEmpty: [ 0 ] ifNotEmpty: [ (aCollection  collect: #value) max ].
	max ~= 0 
	ifTrue: [ 
	aCollection do: [:assoc | | line lineColor | 
		line := self textArea lines at: assoc key.
		lineColor := self normalizeValue: assoc value max: max.
		self textArea addSegment: (PyRubHighlightSegmentMorph new from: line first to: line last+1;
		colorLine: lineColor )] ].