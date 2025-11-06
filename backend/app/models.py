from pydantic import BaseModel

class TaskIn(BaseModel):
    title: str
