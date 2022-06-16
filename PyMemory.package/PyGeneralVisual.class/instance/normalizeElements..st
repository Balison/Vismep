hooks
normalizeElements: els
	"Normalize the elements features"

	| problematicElements |
	problematicElements := els select: [ :el | el model isUnreachable ].
	problematicElements do: [ :el | el color: Color gray ].
	RTMetricNormalizer new
		elements: els;
		normalizeWidth: #memory
			min: 5
			max: 20
			using: self transformation;
		normalizeHeight: #timesExecuted
			min: 5
			max: 20
			using: self transformation.
	RTMetricNormalizer new
		elements: (els reject: [ :el | el model isUnreachable ]);
		normalizeColor: [ :e | e size ]
			using:
			{self defaultColorBoxes.
			self colorBoxes}
			using: #sqrt.