import linecache
import os
import csv
import inspect
import sys
import tracemalloc
import py_compile
import threading
import runpy


def display_top(name, snapshot, key_type='lineno', limit=10000):
    snapshot = snapshot.filter_traces((
        tracemalloc.Filter(False, "tracemalloc.__file__"),
        tracemalloc.Filter(False, "*py_compile.py"),
        tracemalloc.Filter(False, "*runpy.py"),
        tracemalloc.Filter(False, "*AlMemory.py"),
        tracemalloc.Filter(False, "*AlTrace.py"),
        tracemalloc.Filter(False, "<*>"),
        #tracemalloc.Filter(False, "*lib/python*"),
    ))

    top_stats = snapshot.statistics(key_type, cumulative=True)
    headers = ['N','FileName','Line','Memory']
    with open("AlProfiler_" + name + "/AlMemory" + name + ".csv", "w") as writeFile:
        memoryFile = csv.writer(writeFile)
        memoryFile.writerow(headers)

        for index, stat in enumerate(top_stats[:limit], 1):
            frame = stat.traceback[0]
            filename = frame.filename
            memoryFile.writerow([index, filename, frame.lineno, (stat.size / 1024)])

    other = top_stats[limit:]
    if other:
        size = sum(stat.size for stat in other)
        print("%s other: %.1f KiB" % (len(other), size / 1024))
    total = sum(stat.size for stat in top_stats)
    print("Total allocated size: %.1f KiB" % (total / 1024))
    writeFile.close()


def initMemory(name, path):
    py_compile.compile(path)
    tracemalloc.start()
    tracemalloc.clear_traces()
    
    runpy.run_path(path, init_globals=None, run_name="__main__")
    snapshot = tracemalloc.take_snapshot()

    display_top(name, snapshot)
    tracemalloc.stop()
