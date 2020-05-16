hooks
renderOnDemandIn: aView
	| label labelShape myGroup labelGroup |	
	RTVerticalLineLayout on: group.
	labelShape := RTRoundedBox new borderRadius: 14;
		color: ((Color fromHexString: '263238') alpha: 0.6).
	label := labelShape elementOn: onDemandText.
	
	labelGroup := RTGroup new
		add: ((RTStyledLabel new color: Color white; bold) elementOn: '') setAsFixed;
		add: ((RTLabel new color: Color white) elementOn: onDemandText) setAsFixed;
		yourself.
	RTHorizontalLineLayout new gapSize: 0; on: labelGroup.
	RTNest new on: label nest: labelGroup.
	
	
	label setAsFixed.
	label @ RTHighlightable.
	aView add: label; add: labelGroup.
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