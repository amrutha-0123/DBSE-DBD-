from fastapi import APIRouter,HTTPException

router=APIRouter(prefix="/books",tags=["Public Catalog"])
books=[
 {"book_id":1,"title":"The Martian","isbn":"9780553418026","price":499},
 {"book_id":2,"title":"Dune","isbn":"9780441172719","price":599}
]

@router.get("/")
async def get_books():
    return books

@router.get("/{book_id}")
async def get_book(book_id:int):
    for book in books:
        if book["book_id"]==book_id:
            return book
    raise HTTPException(status_code=404,detail="Book not found")
