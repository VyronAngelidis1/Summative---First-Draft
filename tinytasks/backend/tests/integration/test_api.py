from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_create_and_list_tasks():
    r = client.post("/api/tasks", json={"title":"A"})
    assert r.status_code == 201
    r = client.get("/api/tasks")
    assert any(t["title"]=="A" for t in r.json())
