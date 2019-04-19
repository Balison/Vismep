visualization
visualizeFolder: directory
"Given the directory with the csv files, load the information and then visualize it"

	| baseName fullName |
	baseName := directory path basename.
	fullName := directory fullName.
	^ self loadFiles: fullName and: baseName.
	