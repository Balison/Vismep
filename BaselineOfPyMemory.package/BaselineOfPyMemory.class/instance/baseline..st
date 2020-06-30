baselines
baseline: spec
	<baseline>
	spec for: #'common' do: [
		spec postLoadDoIt: #postLoadDoIt.
		spec
			baseline: 'Roassal2' with: [
				spec
					repository: 'github://ObjectProfile/Roassal2:85131fe0c093513009d3106ae7151bb471aac2f0/src' ].
		spec 
			baseline: 'NeoCSV' with: 
			[ spec repository: 'github://svenvc/NeoCSV/repository' ].
		spec package: 'PyMemory'. ].
