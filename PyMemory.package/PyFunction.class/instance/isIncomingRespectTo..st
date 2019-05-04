comparing
isIncomingRespectTo: other
"Return true if the other is called by this function"

	| func |
	func := callsTo keys collect: #key.
	^ (func includes: other).