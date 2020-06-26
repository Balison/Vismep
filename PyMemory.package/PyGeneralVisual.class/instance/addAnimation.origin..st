visualization
addAnimation: aView origin: aOrigin

	| anim |
	anim := RTActiveAnimation new.
	anim intervalInMilliseconds: 1000.
	anim blockToExecute: [ 
		| element event currentBounds currentPosition |
		element := self movePosition ifNil: [ 'Nothing' ] 
											ifNotNil: [ :e | e ].
		event := 'Over'.
		currentPosition := self currentWorld currentHand position.
		currentBounds := aView canvas morph fullBounds.
		(currentBounds containsPoint: currentPosition) 
			ifTrue: [ self logger addTime: Time now asString 
							position: currentPosition 
							view: aOrigin
							element: element 
							event: event. ]].
										
		anim inView: aView.