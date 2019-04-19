hooks
normalizeElements: els
"Normalize the elements features"

	RTMetricNormalizer new
	elements: els;
	normalizeWidth: #memory min: 5 max: 20 using: self transformation;
	normalizeHeight: #timesExecuted min: 5 max: 20 using: self transformation;
	normalizeColor: [ :e | e size ]
		using:
		{self defaultColorBoxes .
		self colorBoxes}
		using: #sqrt.