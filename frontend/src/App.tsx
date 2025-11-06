import { useEffect, useState } from "react";

type Task = { id: number; title: string };

export default function App() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [title, setTitle] = useState("");

  const load = async () => {
    const r = await fetch("/api/tasks");
    setTasks(await r.json());
  };
  useEffect(() => { load(); }, []);

  const add = async () => {
    if (!title.trim()) return;
    await fetch("/api/tasks", {
      method: "POST",
      headers: { "Content-Type": "application/json"},
      body: JSON.stringify({ title })
    });
    setTitle("");
    await load();
  };

  const del = async (id:number) => {
    await fetch(`/api/tasks/${id}`, { method: "DELETE" });
    await load();
  };

  return (
    <main style={{maxWidth:680, margin:'2rem auto', fontFamily:'system-ui'}}>
      <h1>TinyTasks</h1>
      <p style={{opacity:0.7}}>Simple task list to demo DevOps pipeline.</p>
      <div style={{display:'flex', gap:8}}>
        <input value={title} onChange={e=>setTitle(e.target.value)} placeholder="Add a task" style={{flex:1, padding:8}}/>
        <button onClick={add} style={{padding:'8px 12px'}}>Add</button>
      </div>
      <ul>
        {tasks.map(t => (
          <li key={t.id} style={{marginTop:8}}>
            {t.title}{" "}
            <button onClick={()=>del(t.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </main>
  );
}
