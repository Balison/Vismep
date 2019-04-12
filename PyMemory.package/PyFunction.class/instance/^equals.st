comparing
= other
"A Pyfunction is equal to other if they have the same name on the same file"

	^ other class = self class and: [ (self code = other code) ]