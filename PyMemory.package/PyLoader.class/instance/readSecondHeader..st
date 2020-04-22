action
readSecondHeader: relation 
	"comment stating purpose of message"
	| caller |
	caller := model at: relation first -> relation second
			ifPresent: [ model at: relation first -> relation second ]
			ifAbsent: [ PyFunction newFile: relation second name: relation first ].
	
	^ caller