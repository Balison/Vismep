as yet unclassified
callNobody

	^ self callsTo isEmpty or: [ self callsTo allSatisfy: [ :assoc | assoc key = self ] ]