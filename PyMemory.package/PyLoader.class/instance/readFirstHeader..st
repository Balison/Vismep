action
readFirstHeader: line 
	"comment stating purpose of message"
	|  fun relation |
	relation := line splitOn: #,.
			fun := model at: relation second -> relation third 
				ifPresent: [ (model at: relation second -> relation third) ]
				ifAbsent: [ (PyFunction newFile: relation third 
								name: relation second) ].
							
			fun thread: relation first asNumber;
				lineStart: relation fourth asNumber; 
				lineEnd: (relation fourth asNumber + relation fifth asNumber - 1);
				timesExecuted: relation sixth asNumber.
	^ fun