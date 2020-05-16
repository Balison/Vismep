action
openDirectory

	| directory |
	directory := UIManager default chooseDirectory.
	directory ifNil: [ ^ self inform: 'You did not choose a directory.' ].
	LastDirectory := directory.
	^ (PyLoader new visualizeFolder: directory) inspect.