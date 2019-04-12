hooks
normalizeElements: els
"Normalize the elements features"

	RTMetricNormalizer new
	elements: els;
	normalizeWidth: #memory;
	normalizeHeight: #timesExecuted;
	normalizeColor: [ :e | e size ]
		using:
		{self defaultColorBoxes .
		self colorBoxes}
		using: #sqrt.