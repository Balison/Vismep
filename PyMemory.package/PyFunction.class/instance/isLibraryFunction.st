accessing
isLibraryFunction

	isLibrary ifNil: [ isLibrary := '*lib#python*' match: file ].
	^ isLibrary