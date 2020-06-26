visualization
visualizeCall: aModel with: aLog
"Visualize a subgraph of this function"

	log := aLog.
	view ifNil: [ 
		view := RTView new.
		PyFunctionVisual new model: aModel;
						logger: aLog;
						function: self;
						 renderIn: view;
						release.
		 ].
	^ view