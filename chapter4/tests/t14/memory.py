import array
from memory_profiler import memory_usage

def allocate(size):
    some_var = array.array('l', range(size))

usage = memory_usage((allocate, (int(1e7),)))
peak = max(usage)
print(f"Usage over time: {usage}")
print(f"Peak usage: {peak}")
