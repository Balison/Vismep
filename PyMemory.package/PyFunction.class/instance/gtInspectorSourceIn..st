gt-inspector-extension
gtInspectorSourceIn: composite
	<gtInspectorPresentationOrder: 1>
	^ composite morph
		title: 'Source';
		display: [ | morph |
			morph :=
			PyRubScrolledTextMorph new 
   						withLineNumbers;
						beReadOnly;
   						appendText: self sourceCode.
			codeState ifTrue: [ morph highlightLines: (memoryLines associations) ].
			morph ].
	