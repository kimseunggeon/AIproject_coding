import subprocess, shlex, time, json

def newline_split(s:str):
    ret : list = []
    for line in s.split("\n"):
        ret.append(line)
    return ret

def pipe_run(args:list[str]):
    with subprocess.Popen(args, stdin=subprocess.PIPE,  stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8', text=True) as proc: #open shell & run code
        err : list = []
        stdout, stderr = proc.communicate()
        output=newline_split(stdout)
        err=newline_split(stderr)   
        print(output)
        return [output[:-1], err] #return stdout 