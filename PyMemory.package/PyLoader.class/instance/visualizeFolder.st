visualization
visualizeFolder
"Open a UIManager to select the directory with the csv files, load the information and then visualize it"

	| files directory |
	directory := UIManager default chooseDirectory.
	files := directory allChildren.
	self loadFunctions: (files detect: [ :file | file basename beginsWith: 'functions.csv' ]).
	self loadCall: (files detect: [ :file | file basename beginsWith: 'calls.csv' ]).
	self loadLines: (files detect: [ :file | file basename beginsWith: 'lines.csv' ]).
	self updateMemory: (files detect: [ :file | file basename beginsWith: 'memory.csv' ]).
	^ self visualize
	