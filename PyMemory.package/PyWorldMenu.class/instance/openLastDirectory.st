action
openLastDirectory
	LastDirectory ifNil: [ ^ self inform: 'These isn''t a last directory.' ].
	LastDirectory asFileReference exists
		ifNil: [ ^ self inform: 'Last directory doesn''t exist anymore.' ].
	self visualizeDirectory.