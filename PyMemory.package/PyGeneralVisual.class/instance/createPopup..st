visualization
createPopup: els
"Create pop ups for the elements"

	els @ (RTPopup new
			borderColor: Color gray;
			alphaPopupBackground: 0.8;
			named: [ :e | '' ]
			background: Color lightGray
			group: self popupBlock).
	