// MongoDB / mongosh script
// Run this file in mongosh, not PostgreSQL psql.

-- SESSION 5: MongoDB CRUD
-- This file is for mongosh, NOT PostgreSQL psql.
-- Run: mongosh
-- Then paste this file.

use dbms_session5;

db.customers.deleteMany({});
db.products.deleteMany({});

-- CREATE
db.customers.insertMany([
    {
        _id: 1,
        name: "Asha",
        email: "asha@example.com",
        addresses: [
            {city: "Hyderabad", pincode: "500001"}
        ]
    },
    {
        _id: 2,
        name: "Ravi",
        email: "ravi@example.com",
        addresses: [
            {city: "Bengaluru", pincode: "560001"}
        ]
    }
]);

db.products.insertMany([
    {_id: 101, name: "Keyboard", price: 1499, category: "Accessories"},
    {_id: 102, name: "Mouse", price: 799, category: "Accessories"}
]);

-- READ
db.products.find();

db.products.find({
    price: {$gt: 1000}
});

db.products.find({
    $or: [
        {category: "Accessories"},
        {price: {$lt: 900}}
    ]
});

db.products.find({
    name: /^Key/i
});

-- UPDATE
db.products.updateOne(
    {_id: 101},
    {$set: {price: 1599}}
);

db.customers.updateOne(
    {_id: 1},
    {$push: {
        addresses: {
            city: "Warangal",
            pincode: "506001"
        }
    }}
);

-- DELETE
db.products.deleteOne({_id: 102});

-- Array operator
db.customers.find({
    "addresses.city": {
        $in: ["Hyderabad", "Warangal"]
    }
});

-- Element operator
db.customers.find({
    email: {$exists: true}
});
