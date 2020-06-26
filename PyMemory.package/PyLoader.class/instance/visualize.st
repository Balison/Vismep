visualization
visualize
"Visualize the functions loaded and expand the model to each one"
	| visual |
	visual := PyVisual new model: model.
	model valuesDo: [ :v | v visualizeCall: model with: visual logger. ].
	Transcript show: 'Starting log';cr.
	^ visual.