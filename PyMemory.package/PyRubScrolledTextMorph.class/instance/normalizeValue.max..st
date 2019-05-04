accessing
normalizeValue: v max: max

	| t tt |
	t := v sqrt.
	tt := 0 + ((1.0 - 0) * ( (t - 0) / (max sqrt - 0))).
	^ self normalizer level: tt.

