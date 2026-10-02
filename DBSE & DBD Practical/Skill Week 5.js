// SKILL SESSION 05: MONGODB — DOCUMENT DATABASE ENGINEERING
// Run with mongosh.

use("bookflow_skill_db");

db.books.drop();

db.books.insertMany([
    {
        title: "The Martian",
        isbn: "9780553418026",
        category: "Science Fiction",
        member_id: 1,
        reviews: [
            { rating: 5, comment: "Amazing space story" },
            { rating: 4, comment: "Very engaging" }
        ]
    },
    {
        title: "Clean Code",
        isbn: "9780132350884",
        category: "Programming",
        member_id: 2,
        reviews: [
            { rating: 5, comment: "Useful programming practices" }
        ]
    }
]);

// CREATE / INSERT
db.books.insertOne({
    title: "Dune",
    isbn: "9780441172719",
    category: "Science Fiction",
    member_id: 3,
    reviews: []
});

// READ
db.books.find();

// UPDATE
db.books.updateOne(
    { isbn: "9780441172719" },
    { $set: { category: "Classic Science Fiction" } }
);

// DELETE
db.books.deleteOne({
    title: "Dune"
});

// Embedded pattern
db.books.find({
    "reviews.rating": { $gte: 4 }
});

// Referenced pattern using member_id
db.books.find({
    member_id: 1
});

// Comparison and logical operators
db.books.find({
    $and: [
        { category: { $exists: true } },
        { member_id: { $in: [1, 2] } }
    ]
});

// Regex
db.books.find({
    title: { $regex: "code", $options: "i" }
});
