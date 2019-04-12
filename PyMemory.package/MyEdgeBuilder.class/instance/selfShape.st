acccessing
selfShape
"Shape used to represent the edge from A to A"

	^ (RTArrowedLine new line: RTBezier4Line new)
					head: (RTSimpleArrowHead new size: 4);
					headOffset: 0.8;
					withBorderAttachPoint;
					color: edgeColor 