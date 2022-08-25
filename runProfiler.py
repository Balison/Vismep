import io
import os
import sys

def generate_call(func_name, args):
    if len(args) == 0:
        call = '{}()'.format(func_name)
    else:
        realArgs = list(map(ast.literal_eval, args))
        listArgs = ''
        mappedArgs = '{}'
        i = 0
        while i < len(realArgs): 
            if i == len(realArgs) - 1:
                listArgs = listArgs + mappedArgs.format(realArgs[i]) 
            else:
                listArgs = listArgs + mappedArgs.format(realArgs[i]) + ','
            i += 1
        call = '{}({})'.format(func_name, listArgs)

    return call



def generate_tmp_executable(filename, func_name, call, defpath, filepath):
    program = '''from vismep import VismepProfiler
import sys
sys.path.insert(0, '{}')
from {} import {}
profiler = VismepProfiler()
profiler.enable("{}","{}")
{}
profiler.disable()
'''.format(os.path.dirname(filepath), filename, func_name, filename, defpath, call)
    with open('tmp_Vismep_all.py', 'w') as f:
        f.write(program)
    f.close()


def run_executable():
    ns = {}
    filename = 'tmp_Vismep_all.py'
    try:
        with io.open(filename, encoding='utf-8') as f:
            exec(compile(f.read(), filename, 'exec'), ns, ns)
        f.close()
    finally:
        print("Executing...")


def main(defpath, filename, func_name, args):
    from datetime import datetime
    now = datetime.now()
    print(now)

    absolute = os.path.abspath(filename)
    base = os.path.basename(absolute)
    name = os.path.splitext(base)[0]

    call = generate_call(func_name, args)

    generate_tmp_executable(name, func_name, call, defpath, filename)
    run_executable()

    now = datetime.now()
    print(now)

main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4:])
