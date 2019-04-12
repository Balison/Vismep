visualization
highlightNode: anElement

	anElement trachelShape
		strokePaint: (self highlightNodeColor alpha: 0.7);
		strokeWidth: (4 min: anElement width / 2.5)