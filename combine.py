import sys
import re

def process(filename):
    with open(filename) as f:
        lines = f.readlines()
    for line in lines:
        if line.startswith("require"):
            nfile = re.match(r'require *"(.*)"',line).groups()[0]
            process(nfile+".lua")
        else:
            sys.stdout.write(line)

if __name__ == '__main__':
    entrypoint = sys.argv[1]
    process(entrypoint)

