from datetime import date
from pathlib import Path
from fastapi import FastAPI, BackgroundTasks, Depends
from pydantic import BaseModel, Field, field_validator
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

DATABASE_URL = "postgresql+asyncpg://postgres:postgres@localhost:5432/bookflow_db"
engine = create_async_engine(DATABASE_URL)
SessionLocal = async_sessionmaker(engine, expire_on_commit=False)
app = FastAPI(title="BookFlow API")

class BookSchema(BaseModel):
    title: str
    isbn: str = Field(min_length=13, max_length=13)
    price: float = Field(gt=0)
    published_date: date

    @field_validator("published_date")
    @classmethod
    def valid_date(cls, value):
        if value > date.today():
            raise ValueError("published_date cannot be in the future")
        return value

class RegisterSchema(BaseModel):
    username: str
    password: str = Field(min_length=8)

async def get_db():
    async with SessionLocal() as db:
        yield db

def log_book(title: str):
    with Path("book_events.txt").open("a", encoding="utf-8") as f:
        f.write(f"New Book Added: {title}\n")

@app.post("/books", status_code=201)
async def create_book(book: BookSchema, background_tasks: BackgroundTasks,
                      db: AsyncSession = Depends(get_db)):
    result = await db.execute(text("""
        INSERT INTO Books(title,isbn,published_year,price,published_date)
        VALUES(:title,:isbn,:year,:price,:date)
        RETURNING book_id
    """), {"title":book.title,"isbn":book.isbn,"year":book.published_date.year,
           "price":book.price,"date":book.published_date})
    book_id = result.scalar_one()
    await db.commit()
    background_tasks.add_task(log_book, book.title)
    return {"book_id":book_id,"message":"Book added"}

@app.get("/books/search")
async def search_books(q: str, db: AsyncSession = Depends(get_db)):
    vector = "[0.12,0.78,0.22]"
    result = await db.execute(text("""
        SELECT book_id,title,isbn,published_year,
               embedding <=> CAST(:vector AS vector) AS cosine_distance
        FROM Books
        WHERE embedding IS NOT NULL
        ORDER BY embedding <=> CAST(:vector AS vector)
        LIMIT 10
    """), {"vector":vector})
    return {"query":q,"results":[dict(x) for x in result.mappings().all()]}

@app.post("/members/register")
async def register(member: RegisterSchema):
    from passlib.context import CryptContext
    pwd = CryptContext(schemes=["bcrypt"], deprecated="auto")
    return {"username":member.username,"password_hash":pwd.hash(member.password)}
