from typing import List
from starlette.responses import FileResponse
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.exceptions import HTTPException

from pydantic import BaseModel
import joblib
import tensorflow as tf
import json
import os
import subprocess, shlex, time, json
from pipe import pipe_run

app = FastAPI()

class Code(BaseModel):
    lang: str
    code: str

class Name(BaseModel):
    name: str
    file: str

class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)


manager = ConnectionManager()


@app.get("/")
def root():
    return {"title":"Compiler API"}

@app.post('/compile')
def compile_code(code:Code):
    if code.lang == 'python':
        timestamp = int(time.clock_gettime(1))
        file_name = str(timestamp) + "_py" +'.py'
        with open(file=file_name, mode="w") as f:
            f.write(code.code)
        command_line = 'python3 ' + file_name
        args = shlex.split(command_line)
        output=[]
        err=[]
        a=pipe_run(args)
        output.append(a[0])
        err.append(a[1])
        return {"output": output,"err":err}
        

    else:
        return {"output": "", "error": "This language does not support."}
    



@app.post("/download_model")
async def download_model(code:Name):
    model_path = code.name+code.file  # 모델 파일 경로
    if os.path.exists(model_path):
        return FileResponse(model_path, filename=model_path, media_type="application/octet-stream")
    else:
        return "모델 파일을 찾을 수 없습니다."
"""
websocket in "compile_ml"
1. msg는 json구조로 이루어져 있음. 다음과 같은 구조로 서버에 보낸다.
{
    "lang" : "ML",
    "code" : "" 
}
"""

@app.websocket("/ws/compile_ml")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    await websocket.send_text("Successfully Connected!")
    time.sleep(1)
    try:
        while True:
            text = await websocket.receive_text()
            data = json.loads(text) #json으로 직렬화
            if(data["lang"] == "ML"):
                timestamp = int(time.clock_gettime(1)) # make Timestamp
                file_name = str(timestamp) + "_ml" + '.py'
                with open(file=file_name, mode="w") as f:
                    f.write(data['code']) # write code to file
                command_line = 'python3 ' + file_name #make cmd line to run python script
                args = shlex.split(command_line)
                time.sleep(1)
                with subprocess.Popen(args, stdin=subprocess.PIPE,  stdout=subprocess.PIPE, stderr=subprocess.PIPE) as proc: #open shell & run code
                    stdout, stderr = proc.communicate()
                    await manager.send_personal_message(stdout, websocket)
                await manager.send_personal_message("done", websocket=websocket)
                time.sleep(1)
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        print('Annonymous user left the ML compile route')

