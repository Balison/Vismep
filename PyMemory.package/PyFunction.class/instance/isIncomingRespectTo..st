comparing
isIncomingRespectTo: other
"Return true if the other is called by this function"

	| func |
	func := callsTo collect: #key.
	^ (func includes: other).