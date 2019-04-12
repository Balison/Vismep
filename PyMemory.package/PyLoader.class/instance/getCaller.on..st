action
getCaller: relation on: index
"Given the information of the row and the index we create or update the function"

	^ (index == 1) 
	ifFalse: [  model at: relation second -> relation fourth
					ifPresent: [ :function | function thread: relation first asNumber.  ]
					ifAbsent: [ PyFunction newFile: relation fourth 
											name: relation second thread: relation first asNumber. ] ]
	ifTrue: [ PyRoot new ].