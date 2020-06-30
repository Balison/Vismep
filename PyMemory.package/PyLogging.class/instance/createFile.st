initialization
createFile 
	
	| file |
	file := FileLocator imageDirectory / 'LoggingPython.csv'.
	(File named: file fullName) writeStream.