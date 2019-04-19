hooks
createLabels: els
"Create some labels for the elements"

	els do: [ :el | el @ (RTLabeled new
				text: [ :e | e name ];
				top;
				fontSize: 5;
				color: Color black;
				setAsShouldBeInTheFront;
				setAsHighlightable)].