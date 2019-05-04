action
continueLoad: relation on: index
"Continue the load of the call if the files are correct and the first line is from module"

	^ (self correctFiles: relation fourth and: relation sixth) or: [ index == 1 and: relation second = '<module>' ]