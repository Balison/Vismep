gt-inspector-extension
gtInspectorSourceIn: composite
	<gtInspectorPresentationOrder: 1>
	^ composite morph
		title: 'Source';
		display: [ | morphCode |
			morphCode := PyRubScrolledTextMorph new 
   						withLineNumbers;
						beReadOnly;
   						appendText: self sourceCode.
		codeState ifTrue: [ morphCode highlightLines: (memoryLines associations) ].
		morphCode on: #mouseEnter send: #inCode to: self.
	
		morphCode ].
	