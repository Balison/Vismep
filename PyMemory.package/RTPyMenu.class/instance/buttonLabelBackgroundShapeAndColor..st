accessing
buttonLabelBackgroundShapeAndColor: aColor
	| box |
	
	box := TRRoundedBoxShape new borderRadius: 14; extent: label encompassingRectangle extent + (10@7).
	self labelBackground: box.
	box color: aColor.
	self saveLabelBackgroundColor.
	box strokePaint: nil.
	TRConstraint move: box onTheCenterOf: label.

	view canvas addFixedShape: box.
	box pushBack.