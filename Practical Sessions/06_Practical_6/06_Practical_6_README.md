# Practical 6 — Organized FastAPI Routing

## Requirements
- Python 3.10+
- FastAPI
- Uvicorn

## Run

From this folder:

```bash
python -m venv venv
```

Windows PowerShell:

```powershell
venv\Scripts\activate
```

Install:

```bash
pip install fastapi uvicorn
```

Start:

```bash
uvicorn main:app --reload
```

Open:

`http://127.0.0.1:8000/docs`

The public catalog routes are under `/books` and admin CRUD routes are under `/admin/books`.
