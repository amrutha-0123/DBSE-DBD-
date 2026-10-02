# Practical 7 — Node.js User Service

## Requirements
- Node.js
- MongoDB Server

## Run

From this folder:

```bash
npm install
```

Make sure MongoDB is running.

Then:

```bash
npm start
```

The service listens on:

`http://localhost:5001`

Endpoints:
- `POST /users`
- `GET /users/:id`
- `POST /activities`
- `GET /activities/:user_id`

The default MongoDB database is `bookflow_users`.

To use another MongoDB connection string, set `MONGO_URI` before starting the server.
