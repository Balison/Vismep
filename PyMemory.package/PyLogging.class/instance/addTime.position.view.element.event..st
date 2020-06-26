initialization
addTime: aTime position: aPosition view: aView element: aElement event: aEvent

	data add: (Array with: aTime with: aPosition with: aView with: aElement with: aEvent).
	Transcript show: 'Hora:' , Time now asString, 
												' Position: ', aPosition  asString,
												' Vista: ' , aView ,
												' Elemento: ', aElement  asString,
												' Evento: ', aEvent asString; cr.

	