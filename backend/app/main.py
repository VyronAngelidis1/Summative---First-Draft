import logging, os, time, json
from typing import List
from fastapi import FastAPI, Request, HTTPException
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

# --- Structured JSON logging
class JsonFormatter(logging.Formatter):
    def format(self, record):
        base = {
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
            "time": int(time.time()),
        }
        if record.exc_info:
            base["exc_info"] = self.formatException(record.exc_info)
        return json.dumps(base)

handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())
logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"), handlers=[handler])
log = logging.getLogger("tinytasks")

app = FastAPI(title="TinyTasks")

# Simple in-memory store
TASKS: list[dict] = []

class TaskIn(BaseModel):
    title: str

class Task(TaskIn):
    id: int

@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    resp = await call_next(request)
    dur_ms = int((time.time() - start) * 1000)
    log.info(json.dumps({
        "path": request.url.path,
        "method": request.method,
        "status": resp.status_code,
        "dur_ms": dur_ms
    }))
    return resp

@app.get("/api/health")
def health():
    return {"ok": True}

@app.get("/api/tasks", response_model=List[Task])
def list_tasks():
    return TASKS

@app.post("/api/tasks", response_model=Task, status_code=201)
def create_task(task: TaskIn):
    new = Task(id=len(TASKS)+1, title=task.title)
    TASKS.append(new.model_dump())
    return new

@app.delete("/api/tasks/{task_id}", status_code=204)
def delete_task(task_id: int):
    idx = next((i for i,t in enumerate(TASKS) if t["id"]==task_id), None)
    if idx is None:
        raise HTTPException(404, "Not found")
    TASKS.pop(idx)

FRONTEND_DIR = os.getenv("FRONTEND_DIR", "/app/frontend/dist")
if os.path.isdir(FRONTEND_DIR):
    app.mount("/", StaticFiles(directory=FRONTEND_DIR, html=True), name="static")
