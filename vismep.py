import sys
import re
import os
import inspect
import csv
from psutil import Process
import linecache

class PyFunction:

    def __init__(self, name, filename, line_start):
        self.name = name
        self.file = filename
        self.times_executed = 0
        self.line_start = line_start
        self.unreachable = False


    def add_size(self, num):
        self.size = num

    def add_execution(self):
        self.times_executed += 1

    def hasissuesize(self):
        return self.line_start == -1 or self.size == -1

    def isunreachable(self):
        return re.match(r"<module>", self.name) != None or self.isfileunreachable()

    def isfileunreachable(self):
        filter_names = [r"^<.*>", r"^<frozen.*>"]
        i = 0
        match = False
        while i < len(filter_names) and match == False:
            if re.match(filter_names[i], self.file) != None:
                match = True
            i = i + 1
        return match

    def isfromprofiler(self):
        filter_names = [r".*runProfiler.py", r".*tmp_Vismep_all.py$", r".*vismep.py$"]
        i = 0
        match = False
        while i < len(filter_names) and match == False:
            if re.match(filter_names[i], self.file) != None:
                match = True
            i = i + 1
        return match
                
    def f_id(self):
        return (self.name, self.file, self.line_start)

    def str_id(self):
        return "{} > {} > {}".format(self.name, self.file, self.line_start)

    def __str__(self):
        return "Function {} executed {} times with size {}".format(self.str_id(), self.times_executed, self.size)

class CallFun:

    def __init__(self, caller, callee, line=None, filename=None):
        self.caller = caller
        self.callee = callee
        self.line = line
        self.filename = filename
        self.containsUnreachable = None

    def involves_profiler(self):
        return self.caller.isfromprofiler() or self.callee.isfromprofiler()

    def c_id(self):
        return (self.caller.name, self.caller.file, self.caller.line_start, self.callee.name, self.callee.file, self.callee.line_start)

    def __str__(self):
        return "Call from {} to {} at line {} in {}.".format(self.caller.str_id(), self.callee.str_id(), self.line, self.filename)


class VismepProfiler():

    def __init__(self):
        self.functions = {}
        self.calls = []
        self.previous_line = None
        self.mem_trace = []
        self.function_mem = []
        self.memory_lines = {}
        self.prev_lines = []
        self.previous_fun = None
        self.stack_fun = []
        self.main_file = None
        self.folder = None


    def add_function(self, name, filename, lineno, size):
        #Update the number of executions if exists
        key = (name, filename, lineno)
        if key not in self.functions:
            f = PyFunction(name, filename, lineno)
        else:
            f = self.functions.get(key)

        f.add_size(size)
        self.functions[f.f_id()] = f
        return f

    def get_start_size(self, frame):

        try:
            current_start = inspect.getsourcelines(frame)[1] 
            current_size = len(inspect.getsourcelines(frame)[0])

        except:
            current_start = -1 
            current_size = -1

        return (current_start, current_size)

    def get_memory_mb(self):
        # get process and memory rss (“Resident Set Size”, this is the non-swapped physical memory a process has used) in MB
        return Process(os.getpid()).memory_info()[0]/float(10 ** 6)

    def add_memory_trace(self, frame):
        name = frame.f_code.co_name
        file = frame.f_code.co_filename
        start = self.get_start_size(frame)[0]

        self.mem_trace.append([name, file, start, self.get_memory_mb(), None])
        #print("Function {} > {} > {} memory info {} MB".format(name, file, start, self.get_memory_mb()))


    def end_memory_trace(self, frame):
        memory = self.get_memory_mb()
        name = frame.f_code.co_name
        file = frame.f_code.co_filename
        start = self.get_start_size(frame)[0]

        current_trace = self.mem_trace.pop()
        self.function_mem.append([current_trace[0], current_trace[1], current_trace[2], current_trace[3], memory])
        #print("Return function {} > {} > {} memory info {} MB".format(name, file, start, memory - current_trace[3]))

    def last_event_profiler(self, current_code, caller_code):
        return caller_code.co_name == '<module>' and re.match(r".*tmp_Vismep_all.py$", caller_code.co_filename) and current_code.co_name == 'disable' and re.match(r".*vismep.py$", current_code.co_filename)

    def receive_call(self, frame):
        current_code = frame.f_code
        current_name = current_code.co_name
        current_lineno = frame.f_lineno
        current_filename = current_code.co_filename

        # frame back
        caller = frame.f_back
        caller_lineno = caller.f_lineno
        caller_name = caller.f_code.co_name
        caller_filename = caller.f_code.co_filename

        #Avoid profiling the root node of profiler
        if self.previous_fun != None:

            if not self.last_event_profiler(current_code, caller.f_code):
                #Create functions corresponding to current function and its caller
                current_start, current_size = self.get_start_size(frame)
                current_func = self.add_function(current_name, current_filename, current_start, current_size)
                caller_start, caller_size = self.get_start_size(caller)
                caller_func = self.add_function(caller_name, caller_filename, caller_start, caller_size)

                current_func.add_execution()

                call = CallFun(caller_func, current_func, caller_lineno, caller_filename)
                self.calls.append(call)
                self.update_stack(current_func)

                #Update previous line
                self.previous_line = ["call", current_name, current_filename, current_start]

                self.add_prev_lines(frame.f_back)



        else:
            current_start, current_size = self.get_start_size(frame)
            current_func = self.add_function(current_name, current_filename, current_start, current_size)
            current_func.add_execution()
            self.update_stack(current_func)

    def update_stack(self, func):
        self.previous_fun = func
        self.stack_fun.append(func)      

    def receive_return(self, frame):
        self.pop_memory_line()

        self.previous_line = ["return", frame.f_code.co_name, frame.f_code.co_filename, frame.f_lineno]
        
        self.previous_to_last(frame)
        self.stack_fun.pop()

    def receive_line(self, frame):
        self.add_prev_lines(frame)

        self.previous_line = ["line", frame.f_code.co_name, frame.f_code.co_filename, frame.f_lineno]

        self.previous_to_last(frame)

    def previous_to_last(self,frame):
        if not(frame.f_code.co_name == 'disable' and re.match(r".*vismep.py$", frame.f_code.co_filename)):
            try:
                self.previous_fun = self.stack_fun[-1]
            except:
                self.previous_fun = None

    def pop_memory_line(self):
        memory = self.get_memory_mb()
        if len(self.prev_lines) != 0:

            last_l = self.prev_lines.pop()
            key_f = (last_l[0], last_l[1], last_l[2])
            memory_last = last_l[4]

            if self.functions.get(key_f) != None:
                #Update the memory for the line (name_fun, filename, line_start, line)
                key_l = (last_l[0], last_l[1], last_l[2], last_l[3])

                if key_l in self.memory_lines:

                    (accum, times) = self.memory_lines.get(key_l)
                    # only consider the increment of memory
                    new_memory = accum + (memory - memory_last) if (memory - memory_last) > 0 else accum
                    new_times = 1 + times


                    self.memory_lines.update({key_l : (new_memory, new_times)})
                    #print("Adding memory line {} memory: {} times: {}".format(key_l, new_memory, new_times))
                else:
                    if (memory - memory_last) > 0:
                        self.memory_lines.update({key_l : (memory - memory_last, 1)})
                        #print("Adding memory line {} memory: {} times: {} porque delta es mayor a 0".format(key_l, memory - memory_last, 1))
                    else:
                        self.memory_lines.update({key_l : (0, 1)})
                        #print("Adding memory line {} memory: {} times: {} porque memory {} memory last {}".format(key_l, 0, 1, memory, memory_last))


    def add_prev_lines(self, frame):
        memory = self.get_memory_mb()
        name = frame.f_code.co_name
        file = frame.f_code.co_filename
        start_line = self.get_start_size(frame)[0]
        line = frame.f_lineno
        self.prev_lines.append([name, file, start_line, line, memory])
  

    def trace_calls(self, frame, event, arg):
        
        if len(self.prev_lines) != 0:
            if event == 'line':
                self.pop_memory_line()

        if event == 'call':
            self.receive_call(frame)
            self.add_memory_trace(frame)
            return self.trace_calls

        elif event == 'return':
            self.end_memory_trace(frame)
            self.receive_return(frame)
            return self.trace_calls

        elif event == 'line':
            self.receive_line(frame)
            return self.trace_calls
        else:
            pass

        return


    def enable(self, filename, defpath):
        self.main_file = filename
        self.def_path = defpath
        sys.settrace(self.trace_calls)

    def disable(self):
        sys.settrace(None)
        #self.show_results()
        self.create_folder()
        self.write_functions()
        self.write_calls()
        self.write_mem_lines()
        self.write_mem_fun()


    def create_folder(self):
        self.folder = self.def_path + "/Vismep_" + self.main_file
        try:  
            os.mkdir(self.folder)
        except OSError:  
            print ("Creation of the directory %s failed" % self.folder)
        else:  
            print ("Successfully created the directory %s " % self.folder)


    def write_functions(self):
        headers = ['Name','Filename','Line_Start','Size','Executions','IsUnreachable']

        with open(self.folder + "/functions.csv", 'w') as func_file:
            trace = csv.writer(func_file)
            trace.writerow(headers)
            for (name, file, start) in self.functions:
                fun = self.functions.get((name, file, start))
                isproblematic = fun.isunreachable() and fun.hasissuesize()
                trace.writerow([name, file, start, fun.size, fun.times_executed, isproblematic])

        func_file.close()

    def write_calls(self):
        headers = ['CallerName','CallerFilename','CallerLine_Start','CalleeName','CalleeFilename','CalleeLine_Start','Occurences']
        calls_structured = {}

        for call in self.calls:
            if call.c_id() not in calls_structured:
                calls_structured[call.c_id()] = 1
            else:
                calls_structured[call.c_id()] = calls_structured.get(call.c_id()) + 1


        with open(self.folder + "/calls.csv", 'w') as call_file:
            trace = csv.writer(call_file)
            trace.writerow(headers)
            for (fname, ffile, fline, sname, sfile, sline) in calls_structured:
                key = (fname, ffile, fline, sname, sfile, sline)
                occ = calls_structured.get(key)
                trace.writerow([fname, ffile, fline, sname, sfile, sline, occ])

        call_file.close()


    def write_mem_lines(self):
        headers = ['Function','Filename','Line_Start','Line','Memory']

        with open(self.folder + "/lines.csv", 'w') as line_file:
            trace = csv.writer(line_file)
            trace.writerow(headers)

            for (name, file, start, line) in self.memory_lines:
                lineinfo = self.memory_lines.get((name, file, start, line))
                if re.match(r"^<.*>", name): 
                    inner = self.search_container(name, file, start, line)
                    if inner != None:
                        lineinfo = inner

                trace.writerow([name, file, start, line, lineinfo[0]])
        line_file.close()

    def write_mem_fun(self):
        headers = ['Function','Filename','Line_Start','Memory_Start','Memory_End']

        with open(self.folder + "/memory.csv", 'w') as mem_file:
            trace = csv.writer(mem_file)
            trace.writerow(headers)

            for memtrace in self.function_mem:
                trace.writerow(memtrace)

        mem_file.close()


    def search_container(self, sname, sfile, sstart, sline):
        for (name, file, start, line) in self.memory_lines:
            if name != sname and file == sfile and start == sstart and line == sline:
                return self.memory_lines.get((name, file, start, line))
        return None

    def show_results(self):
        print("***********************")
        print("Calls involves profiler:")       

        for call in self.calls:
            if call.involves_profiler():
                print(call)

        print("=======================")
        print("Involves Unreachable or issued functions")
        print(self.stack_fun)
        print(self.prev_lines)
            