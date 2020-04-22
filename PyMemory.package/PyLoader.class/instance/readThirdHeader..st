action
readThirdHeader: relation 
	"comment stating purpose of message"
	| callee |
	callee := model at: relation first -> relation second
		ifPresent: [ model at: relation first -> relation second ]
		ifAbsent: [ PyFunction newFile: relation second name: relation first ].
					
	^ callee