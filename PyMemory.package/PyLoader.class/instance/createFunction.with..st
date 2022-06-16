action
createFunction: line with: count
	"Create a funtion based on line name, file, linestart, size, executions, isunreachable"

	| fun data |
	data := line splitOn: #,.
	fun := PyFunction newFile: data second name: data first.
	fun
		order: count;
		lineStart: data third asNumber;
		lineEnd: data third asNumber + data fourth asNumber - 1;
		timesExecuted: data fifth asNumber;
		isUnreachable: data sixth ~= 'False'.
	^ fun