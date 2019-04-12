visualization
visualizeCall: aModel
"Visualize a subgraph of this function"

	view ifNil: [ 
		view := RTView new.
		PyFunctionVisual new model: aModel;
						function: self;
						 renderIn: view;
						release.
		 ].
	^ view