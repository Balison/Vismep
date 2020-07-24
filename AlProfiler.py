import sys
import re
import os
import gc
import ast
import time
import csv
import threading
import inspect
from psutil import Process

filter_names = [r"^<.*>", r"^<frozen.*>", r".*AlProfiler.py$"]

class PyFunction:

	def __init__(self, name, filename):
		self.name = name
		self.file = filename
		self.times_executed = 0
		self.calls_to = {}
		self.called_by = {}
		self.thread = None
		self.memory = []
		self.uncollected = []
		self.memory_lines = {}

	def init_memory(self, mem):
		self.memory.append((mem, None))

	def end_memory(self, mem):
		x = self.memory.pop()[0]
		self.memory.insert(0, (x, mem))

	def init_unc(self, mem):
		self.uncollected.append((mem, None))

	def end_unc(self, mem):
		x = self.uncollected.pop()[0]
		self.uncollected.insert(0, (x, mem))  

	def init_thread(self, thread):
		self.thread = thread

	def init_lines(self, start, end):
		self.line_start = start
		self.line_end = end

	def add_execution(self):
		self.times_executed += 1

	def add_memory_line(self, line, mem):
		if line in self.memory_lines:
			(accum, times) = self.memory_lines.get(line)
			new_mem = accum + mem if mem > 0 else accum
			new_times = 1 + times
			self.memory_lines.update({line : (new_mem, new_times)})
		else:
			if mem > 0:
				self.memory_lines.update({line : (mem, 1)})
			else: 
				self.memory_lines.update({line : (0, 1)})
		#print("		memory lines of {}".format(self.name))
		#print(self.memory_lines)
				

	def f_id(self):
		return (self.name, self.file)

	def add_call_to(self, function, line):
		key_f = function.f_id()
		if key_f not in self.calls_to:
			lines = {line : 1}
		else:
			lines = self.calls_to.get(key_f)
			if line in lines:
				times = lines.get(line) + 1
				lines.update({line : times})
			else:
				lines.update({line : 1})
		self.calls_to.update({key_f : lines})


	def add_called_by(self, function):
		key_f = function.f_id()
		if key_f not in self.called_by:
			self.called_by.update({key_f : 1})
		else:
			times = self.called_by.get(key_f)
			self.called_by.update({key_f : times + 1})

	def pretty_print(self):
		print("Function: {} file: {} thread: {} from: {} to: {} executed: {}".format(self.name, self.file, self.thread, self.line_start, self.line_end, self.times_executed))
		for x in self.memory:
			if x[1] - x[0] > 0:
				print("Memor {} :".format(x))
		for x in self.uncollected:
			if x[1] - x[0] > 0:
				print("Uncoll {} :".format(x))
		print(len(self.memory))
		print(len(self.uncollected))
		for x, y in self.memory_lines.items():
			if y[0] != 0:
				print("  On line: {} mem {} executions: {}".format(x, y[0]/ float(2 ** 10), y[1]))
		for x, y in self.calls_to.items():
			for a, b in y.items():
				print("		Call to: {} on line: {} times: {}".format(x[0], a, b))

		for x, y in self.called_by.items():
			print("	Called by: {} times: {}".format(x[0], y))


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

def add_function(name, filename, line_start, line_end, thread=None):
	key = (name, filename)
	if key not in functions:
		f = PyFunction(name, filename)
		if (f.thread == None) & (thread != None):
			f.init_thread(thread)
		f.init_lines(line_start, line_end)
		return f
	else:
		a = functions.get(key)
		if (a.thread == None) & (thread != None):
			a.init_thread(thread)
		return a

def pop_line(mem):
	if len(last_line) != 0:
		last = last_line.pop()
		#print("		pop {}".format(last))
		#print("pop {}".format(last))
		#print("hay last %s se esta por ejecutar %s %s", (last, fun_name,frame.f_lineno))
		key = (last[0], last[1])
		fun = functions.get(key)
		if fun != None:
			fun.add_memory_line(last[2], mem - last[3])


def profile(frame, event, arg):
	global count
	process = Process(os.getpid())
	mem = process.memory_info()[0]
	code = frame.f_code
	fun_name = code.co_name
	fun_filename = code.co_filename
	#print(last_line)
	if (not filename_filter(fun_filename)) and function_filter(fun_name):
		gar = sum(gc.get_count())

		count += 1
		if count % 10000 == 0: 
			sys.stdout.write("*")
			sys.stdout.flush()

		if len(last_line) != 0:
			if event == 'line':
				process = Process(os.getpid())
				mem = process.memory_info()[0]
				#print("pop line {}".format(fun_name))
				pop_line(mem)

		if event == 'call':
			fun_start = frame.f_lineno
			try: 
				lines_frame = len(inspect.getsourcelines(frame)[0]) 
			except: 
				lines_frame = 0

			exe = add_function(fun_name, fun_filename, fun_start, lines_frame, threading.get_ident())

			
			call = frame.f_back.f_code
			call_name = call.co_name
			call_filename = call.co_filename

			
			if ((not filename_filter(call_filename)) and function_filter(call_name)):
				#print("add call {}".format(call_name))
				process = Process(os.getpid())
				mem = process.memory_info()[0]
				last_line.append((call_name, call_filename, frame.f_back.f_lineno, mem))
				

				call_start = call.co_firstlineno
				call_line = frame.f_back.f_lineno
				try: 
					lines_call = len(inspect.getsourcelines(frame.f_back)[0]) 
				except: 
					lines_call = 0

				caller = add_function(call_name, call_filename, call_start, lines_call)
				caller.add_call_to(exe, call_line)
				exe.add_called_by(caller)
				functions.update({caller.f_id() : caller})

			exe.add_execution()
			process = Process(os.getpid())
			mem = process.memory_info()[0]
			exe.init_memory(mem / float(2 ** 10))
			#print("Call {} by {} mem {}".format(fun_name, frame.f_back.f_code.co_name, mem / float(2 ** 10)))
			#exe.init_unc(sum(list(map(lambda x: x['uncollectable'], gc.get_stats()))))
			exe.init_unc(gar)
			functions.update({exe.f_id() : exe})

			return profile

		elif event == 'return':
			exe = functions.get((fun_name, fun_filename))
			#print("Return {} called {} mem {}".format(fun_name, frame.f_back.f_code.co_name, mem / float(2 ** 10)))
			exe.end_memory(mem / float(2 ** 10))
			exe.end_unc(gar)
			#exe.end_unc(sum(list(map(lambda x: x['uncollectable'], gc.get_stats()))))
			functions.update({exe.f_id() : exe})
			#print("pop return {}".format(fun_name))
			pop_line(mem)

		elif event == 'line':
			#print("add line {}".format(fun_name))
			process = Process(os.getpid())
			mem = process.memory_info()[0]
			last_line.append((fun_name, fun_filename, frame.f_lineno, mem))
				
	else:
		pass

	return


def createProgramTrace(name, path, func_name, args):
	#print(args)
	if len(args) == 0:
		call = '{}()'.format(func_name)
	else:
		realArgs = list(map(ast.literal_eval, args))
		print(realArgs) 
		listArgs = ''
		mappedArgs = '{}'
		i = 0
		while i < len(realArgs): 
			if i == len(realArgs) - 1:
				listArgs = listArgs + mappedArgs.format(realArgs[i]) 
			else:
				listArgs = listArgs + mappedArgs.format(realArgs[i]) + ','
			i += 1
		#print(listArgs)
		call = '{}({})'.format(func_name, listArgs)



	program = '''import sys
sys.path.insert(0, '{}')
from {} import {}
sys.settrace(profile)
{}
sys.settrace(None)'''.format(path, name, func_name, call)
	#print(program)
	return program 

def createFolder(defpath, name):
	
	path = defpath + "/AlProfiler_" + name

	try:  
		os.mkdir(path)
	except OSError:  
		print ("Creation of the directory %s failed" % path)
	else:  
		print ("Successfully created the directory %s " % path)


def main(defpath, filename, func_name, args):
	global last_line, functions, count
	functions = {}
	last_line = []
	from datetime import datetime
	now = datetime.now()
	print(now)
	absolute = os.path.abspath(filename)
	base = os.path.basename(absolute)
	name = os.path.splitext(base)[0]

	createFolder(defpath, name)
	pro = createProgramTrace(name, os.path.dirname(filename), func_name, args)

	sys.stdout.write("Profiling... [*")

	count = 0
	exec(pro)

	count += 1
	if count % 10000 == 0:
		sys.stdout.write("*")
		sys.stdout.flush()

	with open(defpath + "/AlProfiler_" + name + "/AlTrace_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		for x, y in functions.items():
			headers = ['IdThread','Function','Filename','Line_Start','Size','Times']
			trace.writerow(headers)	
			trace.writerow([y.thread,y.name,y.file,y.line_start,y.line_end,y.times_executed])
			trace.writerow(['Calls_to','Filename','Line','Times'])
			for w, v in y.calls_to.items():
				for t, s in v.items():
					trace.writerow([w[0],w[1],t,s])
			trace.writerow(['Called_by','Filename','Times'])
			for w, v in y.called_by.items():
					trace.writerow([w[0],w[1],v])

	traceFile.close()

	headers = ['Function','Filename','Memory_Start','Memory_End']
	with open(defpath + "/AlProfiler_" + name + "/AlMemory_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		trace.writerow(headers)
		for x, y in functions.items():
			for a in y.memory:
				if a[1] - a[0] > 0:
					trace.writerow([y.name,y.file,a[0]/ float(2 ** 10),a[1]/ float(2 ** 10)])
		headers = ['Function','Filename','Uncollected_Start','Uncollected_End']
		trace.writerow(headers)
		for x, y in functions.items():
			for a in y.uncollected:
				trace.writerow([y.name,y.file,a[0],a[1]])
	traceFile.close()

	headers = ['Function','Filename','Line','Memory','Executed']
	with open(defpath + "/AlProfiler_" + name + "/AlLines_" + name + ".csv", 'w') as traceFile:
		trace = csv.writer(traceFile)
		trace.writerow(headers)
		for x, y in functions.items():
			for a, b in y.memory_lines.items():
				if b[0] > 0:
					trace.writerow([y.name,y.file,a,b[0]/ float(2 ** 10),b[1]])
	traceFile.close()

	sys.stdout.write("*]\n")

	now = datetime.now()
	print(now)


main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4:])
