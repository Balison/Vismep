action
correctFiles: aFile and: otherFile
"It's very common have gosth files tracing the native libraries of Python, in this case we ignore them"

	^ ('<*>' match: aFile) not & ('<*>' match: otherFile) not