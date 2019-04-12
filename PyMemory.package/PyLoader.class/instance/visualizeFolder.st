visualization
visualizeFolder
"Open a UIManager to select the directory with the csv files, load the information and then visualize it"

	| baseName directory fullName |
	directory := UIManager default chooseDirectory.
	baseName := directory path basename.
	fullName := directory fullName.
	^ self loadFiles: fullName and: baseName.
	