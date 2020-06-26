visualization
inCode
	
	| currentPosition |
	currentPosition := self currentWorld currentHand position.
	log addTime: Time now 
		position: currentPosition 
		view: 'Source Code ' , self name 
		element: 'Nothing' 
		event: 'Over'.