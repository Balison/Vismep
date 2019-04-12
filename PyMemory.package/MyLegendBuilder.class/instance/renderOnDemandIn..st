hooks
renderOnDemandIn: aView
	| label myGroup |
	RTVerticalLineLayout on: group.
	label := (RTLabel new color: Color black) elementOn: onDemandText.
	label setAsFixed.
	label @ RTHighlightable.
	aView add: label.
	label translateTo: label extent / 2.
	label translateBy: 7@11.
	label
		@
			(RTPopup new
				alphaPopupBackground: self backgroundTransparencyOnDemand;
				background: Color white
					group: [ :gg :el | 
					myGroup := self group.
					gg addAll: (myGroup flatCollect: #yourself) ])