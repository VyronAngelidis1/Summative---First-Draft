from typing import List
from pydantic import BaseModel

class Task(BaseModel):
    id: int
    title: str

def add_task(state: List[Task], title: str) -> Task:
    new = Task(id=len(state)+1, title=title)
    state.append(new)
    return new

def list_tasks(state: List[Task]) -> List[Task]:
    return state
