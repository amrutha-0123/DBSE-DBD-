// SKILL SESSION 06: MONGODB AGGREGATION & DESIGN PATTERNS
// Run with mongosh.

use("bookflow_skill_db");

db.books.drop();

db.books.insertMany([
    {
        title: "The Martian",
        category: "Science Fiction",
        year: 2014,
        reviews: [
            { rating: 5, comment: "Excellent space story" },
            { rating: 4, comment: "Very engaging" }
        ],
        tags: ["space", "science", "adventure"]
    },
    {
        title: "Project Hail Mary",
        category: "Science Fiction",
        year: 2021,
        reviews: [
            { rating: 5, comment: "Fantastic science" },
            { rating: 5, comment: "Great adventure" }
        ],
        tags: ["space", "science"]
    }
]);

// Aggregation: $match, $unwind, $group, $project, $sort, $limit
db.books.aggregate([
    { $match: { year: { $gte: 2020 } } },
    { $unwind: "$reviews" },
    {
        $group: {
            _id: "$title",
            average_rating: { $avg: "$reviews.rating" },
            review_count: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            title: "$_id",
            average_rating: 1,
            review_count: 1
        }
    },
    { $sort: { average_rating: -1 } },
    { $limit: 10 }
]);

// $lookup demonstration: SQL JOIN equivalent
db.members.drop();
db.members.insertMany([
    { member_id: 1, name: "Jhanasri" },
    { member_id: 2, name: "Amrutha" }
]);

db.books.updateOne(
    { title: "The Martian" },
    { $set: { member_id: 1 } }
);

db.books.aggregate([
    {
        $lookup: {
            from: "members",
            localField: "member_id",
            foreignField: "member_id",
            as: "member_details"
        }
    }
]);

// Attribute pattern
db.books.find({
    tags: "space"
});

// Computed pattern
db.books.aggregate([
    {
        $addFields: {
            review_count: { $size: "$reviews" }
        }
    }
]);
