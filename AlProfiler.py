import sys
import re
import os
import gc
import csv
import threading
import inspect
from psutil import Process

filter_names = [r"^<.*>", r"^<frozen.*>", r".*AlProfiler.py$"]

def filename_filter(name):
	i = 0
	match = False
	while i < len(filter_names) and match == False:
		if re.match(filter_names[i], name) != None:
			match = True
		i = i + 1
	return match

def function_filter(name):
	return re.match(r"<module>", name) != None or re.match(r"^<.*>", name) == None

def pop_line(mem):
	if len(last_line) != 0:
		last = last_line.pop()
		#print("pop {}".format(last))
		#print("hay last %s se esta por ejecutar %s %s", (last, fun_name,frame.f_lineno))
		key = (last[0], last[1])
		if key not in line_code_func:
			line_code_func.update({key : {last[2] : (mem - last[3], 1)}})
		else:
			fun_list = line_code_func.get(key)
			if last[2] not in fun_list:
				fun_list.update({last[2] : (mem - last[3], 1)})
			else:
				old = fun_list.get(last[2])
				fun_list.update({last[2] : (((mem - last[3])+old[0]), old[1] + 1)})
			line_code_func.update({key : fun_list})

def profile(frame, event, arg):
	code = frame.f_code
	fun_name = code.co_name
	fun_filename = code.co_filename
	if (not filename_filter(fun_filename)) and function_filter(fun_name):
		if len(last_line) != 0:
			if event == 'line':
				process = Process(os.getpid())
				mem = process.memory_info()[0]
				pop_line(mem)
				#print(last_line)
				#print(line_code_func)

		if event == 'call':
			process = Process(os.getpid())
			mem = process.memory_info()[0]
			memory.append([fun_name, fun_filename, "start", mem / float(2 ** 10), sum(gc.get_count())])

			call = frame.f_back.f_code
			call_name = call.co_name
			call_filename = call.co_filename
			
			if ((not filename_filter(call_filename)) and function_filter(call_name)):
				#print("call {} last {}".format(fun_name, call_name))
				last_line.append((call_name, call_filename, frame.f_back.f_lineno, mem))
				#print(last_line)
				#print(line_code_func)

			#print("call to {} and {} file {}".format(fun_name, call_name, call_filename))
			if ((not filename_filter(call_filename)) and function_filter(call_name)) or (call_name == '<module>'):
				#print("before execute " + fun_name)
				fun_start = frame.f_lineno
				call_start = call.co_firstlineno
				call_line = frame.f_back.f_lineno
				try: 
					lines_call = len(inspect.getsourcelines(frame.f_back)[0]) 
				except: 
					lines_call = 0
				try: 
					lines_frame = len(inspect.getsourcelines(frame)[0]) 
				except: 
					lines_frame = 0

				text.append([threading.get_ident(),call_name,fun_name,call_filename,call_line,fun_filename,fun_start,lines_call,lines_frame,call_start])
				
			#gc.collect()

		elif event == 'return':
			garbage = sum(gc.get_count())

			#print("return")
			#gc.collect()
			process = Process(os.getpid())
			mem = process.memory_info()[0] 
			memory.append([fun_name, fun_filename, "return", mem / float(2 ** 10), garbage])
			#print("return {} last {}".format(fun_name, frame.f_back.f_code.co_name))
			pop_line(mem)
			#print(last_line)
			#print(line_code_func)



		elif event == 'line':
			process = Process(os.getpid())
			mem = process.memory_info()[0]
			last_line.append((fun_name, fun_filename, frame.f_lineno, mem))
			#print("ev {} name {} line {}".format(event,fun_name, frame.f_lineno))
			#print(last_line)
			#print(line_code_func)
	else:
		pass

	return profile


def createProgramTrace(name, path, func_name):
	program = '''import sys
sys.path.append('{}')
import {}
sys.settrace(profile)
{}.{}()
sys.settrace(None)'''.format(path, name, name, func_name)
	#print(program)
	return program 

def createFolder(name):
	
	path = "AlProfiler_" + name

	try:  
		os.mkdir(path)
	except OSError:  
		print ("Creation of the directory %s failed" % path)
	else:  
		print ("Successfully created the directory %s " % path)

def main(filename, func_name):
	global text, memory, line_code_func, last_line
	last_line = []
	text = []
	memory = []
	line_code_func = {}
	from datetime import datetime
	now = datetime.now()
	print(now)
	absolute = os.path.abspath(filename)
	base = os.path.basename(absolute)
	name = os.path.splitext(base)[0]

	createFolder(name)
	pro = createProgramTrace(name, absolute, func_name)

	exec(pro)

	headers = ['IdThread','Caller','Callee','FileCaller','LineOfCall','FileCallee','LineOfDef','SizeCaller','SizeCallee','CallerDef']
	with open("AlProfiler_" + name + "/AlTrace_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		trace.writerow(headers)
		trace.writerows(text)
	traceFile.close()

	headers = ['Function','Filename','Event','Blocks','Garbage']
	with open("AlProfiler_" + name + "/AlMemory_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		trace.writerow(headers)
		trace.writerows(memory)
	traceFile.close()

	headers = ['Function','Filename','Line','Memory','Executed']
	with open("AlProfiler_" + name + "/AlLines_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		trace.writerow(headers)
		for x, y in line_code_func.items():
			for line, m in y.items():
				if m[0] != 0 and (x[0] != '<module>' and x[1] != '<string>'):
					trace.writerow([x[0], x[1], line, m[0]/ float(2 ** 10), m[1]])
	traceFile.close()

	now = datetime.now()
	print(now)

main(sys.argv[1], sys.argv[2])
