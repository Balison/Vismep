import os
import sys
from AlTrace import initTrace
from AlMemory import initMemory

def main(fileName, nameFunc):
	print(fileName)

	absolute = os.path.abspath(fileName)
	base = os.path.basename(absolute)
	name = os.path.splitext(base)[0]

	createFolder(name)

	program = createProgramTrace(name, absolute, nameFunc)
	initTrace(name, program)

	initMemory(name, absolute)


def createProgramTrace(name, path, nameFunc):
	program = '''import sys
sys.path.append('{}')
import {}
from AlTrace import trace_calls
sys.settrace(trace_calls)
{}.{}()
sys.settrace(None)'''.format(path, name, name, nameFunc)
	print(program)
	return program 


def createFolder(name):
	
	path = "AlProfiler_" + name

	try:  
		os.mkdir(path)
	except OSError:  
	    print ("Creation of the directory %s failed" % path)
	else:  
	    print ("Successfully created the directory %s " % path)

main(sys.argv[1], sys.argv[2])