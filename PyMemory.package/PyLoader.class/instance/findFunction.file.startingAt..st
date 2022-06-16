action
findFunction: name file: aFile startingAt: aLine

	| funId |
	funId := name->aFile->aLine.
	^ model at: funId ifPresent: [ :fun | ^ fun ] ifAbsent: [ ^ nil].