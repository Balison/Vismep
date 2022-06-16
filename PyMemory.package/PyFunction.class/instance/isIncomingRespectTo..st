comparing
isIncomingRespectTo: other
"Return true if the other is called by this function"

	| func |
	func := callsTo keys.
	^ (func includes: other).