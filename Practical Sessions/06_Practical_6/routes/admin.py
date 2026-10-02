from fastapi import APIRouter,HTTPException
from pydantic import BaseModel,Field

router=APIRouter(prefix="/admin",tags=["Librarian Admin"])
books=[
 {"book_id":1,"title":"The Martian","isbn":"9780553418026","price":499}
]

class BookInput(BaseModel):
    title:str
    isbn:str
    price:float=Field(ge=0)

@router.post("/books")
async def add_book(book:BookInput):
    new_id=max((b["book_id"] for b in books),default=0)+1
    new_book={"book_id":new_id,**book.model_dump()}
    books.append(new_book)
    return new_book

@router.put("/books/{book_id}")
async def update_book(book_id:int,book:BookInput):
    for i,old in enumerate(books):
        if old["book_id"]==book_id:
            books[i]={"book_id":book_id,**book.model_dump()}
            return books[i]
    raise HTTPException(status_code=404,detail="Book not found")

@router.delete("/books/{book_id}")
async def delete_book(book_id:int):
    for i,book in enumerate(books):
        if book["book_id"]==book_id:
            return books.pop(i)
    raise HTTPException(status_code=404,detail="Book not found")
