event handling
registerTextArea
	super registerTextArea.
	
	textArea announcer  
		when: RubKeystroke send: #whenKeyPressed: to: self;
		when: RubMouseClick send: #whenMouseClicked: to: self;
		when: RubSelectionChanged send: #whenSelectionChanged: to: self.
	self color: colorLine.
	self borderStyle: (self theme rubScrolledTextMorphThemer highlightBorderStyleFor: textArea).
	self borderWidth: 0.