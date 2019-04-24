import sys
import inspect
import threading
import re
import csv
import gc

filterNames = [r"^<frozen.*>", r".*AlTrace.py$", r".*AlMemory.py$", r".*AlProfiler.py$"]

def filename_filter(name):
    i = 0
    match = False
    while i < len(filterNames) and match == False:
        if re.match(filterNames[i], name) != None:
            match = True
        i = i + 1
    return match

def function_filter(name):
    return re.match(r"<module>", name) != None or re.match(r"^<.*>", name) == None

def trace_calls(frame, event, arg):
    co = frame.f_code
    func_name = co.co_name
    func_line_no = frame.f_lineno
    func_filename = co.co_filename
    if (not filename_filter(func_filename)) and function_filter(func_name) and frame != 'exception':
        caller = frame.f_back
        caller_name = caller.f_code.co_name
        caller_filename = caller.f_code.co_filename
        caller_line_no = caller.f_lineno
        if (not filename_filter(caller_filename)) and function_filter(caller_name) and caller != 'exception':
            try: linesCaller = len(inspect.getsourcelines(caller)[0]) 
            except: linesCaller = 0
            try: linesFrame = len(inspect.getsourcelines(frame)[0]) 
            except: linesFrame = 0
            
            text.append([threading.get_ident(),caller_name,func_name,caller_filename,caller_line_no,func_filename,func_line_no,linesCaller,linesFrame,caller.f_code.co_firstlineno,sum(gc.get_count())])
            else:
            pass
    else:
        pass

    return



def initTrace(name, program):
    global text
    text = []
    
    exec(program)

    headers = ['IdThread','Caller','Callee','FileCaller','LineOfCall','FileCallee','LineOfDef','SizeCaller','SizeCallee','CallerDef','Uncollectable']
	with open("AlProfiler_" + name + "/AlTrace" + name + ".csv", 'w') as traceFile:
        trace = csv.writer(traceFile)
        trace.writerow(headers)
        trace.writerows(text)

    traceFile.close()
