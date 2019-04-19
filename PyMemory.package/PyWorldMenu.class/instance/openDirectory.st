action
openDirectory

	| directory |
	directory := UIManager default chooseDirectory.
	LastDirectory := directory.
	^ (PyLoader new visualizeFolder: directory) inspect.