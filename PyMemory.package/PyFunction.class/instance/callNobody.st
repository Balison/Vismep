accessing
callNobody

	^ self callsTo isEmpty or: [ self callsTo keys allSatisfy: [ :assoc | assoc key = self ] ]