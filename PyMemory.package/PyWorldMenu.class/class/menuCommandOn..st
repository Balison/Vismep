world menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: self projectName)
	withSeparatorAfter.
	(aBuilder item: #'Open Directory')
			order: 0.0019; 
			parent: self projectName asSymbol;
			label: 'Open directory';
			action: [ self new openDirectory ].
	(aBuilder item: #'Open last Directory')
			order: 0.0020; 
			parent: self projectName asSymbol;
			label: 'Open last directory';
			action: [ self new openLastDirectory ].