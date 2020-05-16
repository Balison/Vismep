action
openDirectory

	| directory |
	directory := UIManager default chooseDirectory.
	directory ifNil: [ ^ self inform: 'you did not choose a directory.' ].
	LastDirectory := directory.
	^ (PyLoader new visualizeFolder: directory) inspect.