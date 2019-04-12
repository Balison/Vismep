visualization
normalizeEdges: els
"Normalize the width of the edges by the times of calls"

	RTMetricNormalizer new
		elements: els;
		normalizeLineWidth: [:a :b | b calledBy at: a ]
		min: 1
		max: 4.