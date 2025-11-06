from backend.app.repo import add_task, list_tasks

def test_add_and_list():
    state = []
    add_task(state, "Hello")
    add_task(state, "World")
    assert [t.title for t in list_tasks(state)] == ["Hello", "World"]
