# Practical 5 — FastAPI Backend

## Requirements
- Python 3.10+
- PostgreSQL
- `bookflow_db`
- pgvector installed in PostgreSQL

## Run

From this folder:

```bash
python -m venv venv
```

Windows PowerShell:

```powershell
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Before running the API, make sure `main.py` has the correct PostgreSQL username/password.

The database must also have these columns for the POST `/books` example:

```sql
ALTER TABLE Books
ADD COLUMN IF NOT EXISTS price NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS published_date DATE;
```

Start FastAPI:

```bash
uvicorn main:app --reload
```

Open:

`http://127.0.0.1:8000/docs`

Use Swagger UI to test the endpoints.
