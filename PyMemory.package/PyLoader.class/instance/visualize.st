visualization
visualize
"Visualize the functions loaded and expand the model to each one"
	model valuesDo: [ :v | v visualizeCall: model ].
	^ PyVisual new model: model