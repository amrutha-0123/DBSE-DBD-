// MongoDB / mongosh script
// Run this file in mongosh, not PostgreSQL psql.

-- SESSION 6: MongoDB Aggregation Pipeline
-- Run in mongosh

use dbms_session6;

db.orders.drop();

db.orders.insertMany([
    {
        orderId: 1,
        customerId: 101,
        items: [
            {productId: 1, qty: 2, price: 100},
            {productId: 2, qty: 1, price: 50}
        ]
    },
    {
        orderId: 2,
        customerId: 102,
        items: [
            {productId: 1, qty: 3, price: 100}
        ]
    },
    {
        orderId: 3,
        customerId: 101,
        items: [
            {productId: 3, qty: 1, price: 500}
        ]
    }
]);

-- $match
db.orders.aggregate([
    {$match: {customerId: 101}}
]);

-- $unwind
db.orders.aggregate([
    {$unwind: "$items"}
]);

-- $group
db.orders.aggregate([
    {$unwind: "$items"},
    {$group: {
        _id: "$customerId",
        total: {
            $sum: {
                $multiply: ["$items.qty", "$items.price"]
            }
        }
    }}
]);

-- $project
db.orders.aggregate([
    {$project: {
        _id: 0,
        orderId: 1,
        customerId: 1
    }}
]);

-- $sort + $limit
db.orders.aggregate([
    {$sort: {orderId: -1}},
    {$limit: 2}
]);

-- $lookup
db.products.drop();

db.products.insertMany([
    {_id: 1, name: "Keyboard"},
    {_id: 2, name: "Mouse"},
    {_id: 3, name: "Monitor"}
]);

db.orders.aggregate([
    {$unwind: "$items"},
    {$lookup: {
        from: "products",
        localField: "items.productId",
        foreignField: "_id",
        as: "product"
    }},
    {$unwind: "$product"},
    {$project: {
        _id: 0,
        orderId: 1,
        "product.name": 1,
        "items.qty": 1
    }}
]);
