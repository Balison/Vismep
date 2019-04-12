accessing
normalizeValue: v max: max

	| t tt |
	t := v sqrt.
	tt := 0 + ((max - 0) * ( (t - 0) / (max - 0))).
	^ self normalizer level: tt.

