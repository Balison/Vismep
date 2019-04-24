visualization
unhighlightNode: anElement
"Unhighlight an element"

	anElement trachelShape
		strokePaint: (anElement attributeAt: 'borderColor');
		strokeWidth: (anElement attributeAt: 'borderWidth')