# Solace — Local Setup & Run Guide

Solace is a privacy-first messaging application built as an npm workspace monorepo.
It contains a Next.js web client, a Fastify/TypeScript API, MongoDB storage, and a WebCrypto-based end-to-end encryption layer.

## 1. What is included

- `apps/web` — Next.js frontend
- `apps/server` — Fastify backend/APIA
- `packages/crypto` — WebCrypto encryption/key handling
- `packages/design-tokens` — shared UI/design tokens
- `deploy` — Caddy/TURN configuration for production deployments
- `ARCHITECTURE.md` — detailed technical architecture
- `DEPLOYMENT.md` — production deployment notes

**Important:** `node_modules`, `.next`, `dist`, and Git metadata are intentionally not included in this ZIP. That keeps the project small. They are generated locally by `npm install` / the build commands.

## 2. Requirements

Install these before running Solace:

1. **Node.js 18+** (Node 20 LTS is recommended)
2. **npm** (comes with Node.js)
3. **MongoDB** running as a replica set

You can use either:

- A local MongoDB installation configured as a single-node replica set, or
- MongoDB Atlas (recommended if you do not want to configure MongoDB locally)

Check Node/npm:

```bash
node --version
npm --version
```

## 3. Extract the ZIP

Extract the ZIP and open a terminal in the folder containing the root `package.json`.

Example on Windows PowerShell:

```powershell
cd C:\path\to\solace
```

You should see:

```text
package.json
package-lock.json
apps\
packages\
```

## 4. Install dependencies

From the **root Solace folder**, run:

```bash
npm install
```

This recreates the dependencies that were intentionally left out of the ZIP.

Do NOT run `npm install` separately inside `apps/web` or `apps/server` unless you have a specific reason. The repository uses npm workspaces.

## 5. Configure the backend

Copy the example environment file:

### Windows PowerShell

```powershell
Copy-Item apps/server/.env.example apps/server/.env
```

### macOS/Linux

```bash
cp apps/server/.env.example apps/server/.env
```

Open `apps/server/.env` and configure at least:

```env
MONGODB_URL="mongodb://localhost:27017/solace"
JWT_ACCESS_SECRET="your-long-random-secret"
JWT_REFRESH_SECRET="your-different-long-random-secret"
WEB_ORIGIN="http://localhost:3000"
PORT=4000
GIPHY_API_KEY=""
```

For local development, the remaining optional media/TURN settings can stay empty.

**Never commit or share `apps/server/.env`.** It contains secrets.

## 6. Configure the frontend

Copy the example frontend environment file:

### Windows PowerShell

```powershell
Copy-Item apps/web/.env.example apps/web/.env.local
```

### macOS/Linux

```bash
cp apps/web/.env.example apps/web/.env.local
```

The default value is:

```env
NEXT_PUBLIC_API_URL="http://localhost:4000"
```

This means the browser will call the backend on port 4000.

## 7. Set up MongoDB

Solace currently uses **MongoDB only** for its datastore.

A replica set is required because the application uses MongoDB transactions and change streams.

### Option A — MongoDB Atlas

Create an Atlas cluster and copy its connection string. Put it in:

```env
MONGODB_URL="mongodb+srv://USERNAME:PASSWORD@YOUR-CLUSTER/solace?retryWrites=true&w=majority"
```

Then continue to the database setup step.

### Option B — Local MongoDB

Install MongoDB Community Edition and configure MongoDB with a replica set named `rs0`.

Your local connection string can be:

```env
MONGODB_URL="mongodb://localhost:27017/solace?replicaSet=rs0"
```

The repository's `db:setup` script can initialize an already replica-set-enabled local MongoDB instance and then push the Prisma schema.

If MongoDB is running as a standalone server with replication disabled, enable a replica set in its MongoDB configuration and restart MongoDB first.

## 8. Create the database schema

From the project root:

```bash
npm run db:setup
```

This command:

1. Connects to the MongoDB URL in `apps/server/.env`.
2. Detects/initializes a single-node replica set when appropriate.
3. Runs Prisma `db push` to create/update the required collections and indexes.

It does **not** intentionally delete your database.

## 9. Start the backend

Open Terminal 1 in the project root:

```bash
npm run dev:server
```

The API should start on:

```text
http://localhost:4000
```

Useful health endpoints:

```text
http://localhost:4000/health
http://localhost:4000/ready
```

If `/health` works, the API process is running. `/ready` also checks database readiness.

## 10. Start the frontend

Open **Terminal 2**, keep the backend running, and from the same project root run:

```bash
npm run dev:web
```

Next.js should show a local address similar to:

```text
http://localhost:3000
```

Open that address in your browser.

## 11. Quick-start commands

After Node.js and MongoDB are ready, the normal workflow is simply:

### Terminal 1

```bash
cd path/to/solace
npm install
npm run db:setup
npm run dev:server
```

### Terminal 2

```bash
cd path/to/solace
npm run dev:web
```

Then open:

```text
http://localhost:3000
```

## 12. How the project works

The basic flow is:

```text
Browser / Next.js frontend
        |
        | HTTP + WebSocket
        v
Fastify API server
        |
        v
MongoDB
```

Encryption happens in the browser before message content is sent to the server.
The server stores/routs ciphertext and metadata rather than normal plaintext message content.

The crypto package uses browser WebCrypto primitives such as:

- ECDH P-256
- HKDF-SHA256
- AES-256-GCM

See `ARCHITECTURE.md` for the full design.

## 13. Important folders

```text
solace/
├── apps/
│   ├── web/              # Next.js frontend
│   └── server/            # Fastify backend
├── packages/
│   ├── crypto/            # Encryption/key management
│   └── design-tokens/     # Shared UI theme tokens
├── deploy/                # Caddy/TURN deployment configuration
├── package.json           # Root workspace scripts
├── package-lock.json      # Locked npm dependency versions
├── ARCHITECTURE.md        # Architecture + security design
└── DEPLOYMENT.md          # Production deployment guide
```

## 14. Common problems

### `npm` is not recognized

Install Node.js and restart the terminal. Check:

```bash
node --version
npm --version
```

### `Cannot find module` / missing package errors

Run from the root project folder:

```bash
npm install
```

### `MONGODB_URL is not set`

Make sure this file exists:

```text
apps/server/.env
```

and contains `MONGODB_URL=...`.

### MongoDB connection refused

Make sure MongoDB is actually running and that the host/port in `MONGODB_URL` is correct.

### MongoDB says transactions/change streams require a replica set

Solace requires a MongoDB replica set. Use MongoDB Atlas or enable a local replica set named `rs0`.

### Frontend loads but API requests fail

Check:

```env
NEXT_PUBLIC_API_URL="http://localhost:4000"
```

in `apps/web/.env.local`, and make sure the backend is running.

Also make sure the backend has:

```env
WEB_ORIGIN="http://localhost:3000"
```

### Port 3000 or 4000 is already in use

Stop the process using that port, or change the corresponding configuration. If you change the API port, update `NEXT_PUBLIC_API_URL` in the frontend as well.

## 15. Production deployment

For production, do not use the development commands as the final deployment.
See:

- `DEPLOYMENT.md`
- `deploy/Caddyfile`
- `deploy/turnserver.conf`

Production voice/video calling may also require a TURN server depending on network/NAT conditions.

## 16. Security notes

- Do not upload `.env` files containing real secrets to GitHub.
- Do not expose MongoDB publicly without proper authentication/network controls.
- Use HTTPS in production.
- Use strong, different values for `JWT_ACCESS_SECRET` and `JWT_REFRESH_SECRET`.
- The current encryption design intentionally documents its trade-offs in `ARCHITECTURE.md`.

## 17. Useful npm commands

```bash
# Install everything
npm install

# Start frontend
npm run dev:web

# Start backend
npm run dev:server

# Set up MongoDB + Prisma schema
npm run db:setup

# Generate Prisma client
npm run prisma:generate

# Push Prisma schema
npm run db:push

# Build frontend/backend packages
npm run build -w @solace/web
npm run build -w @solace/server

# Run crypto tests
npm test -w @solace/crypto
```

## 18. For a teammate evaluating the project

Give them the ZIP and tell them to:

1. Install Node.js.
2. Install/use MongoDB Atlas (or local MongoDB replica set).
3. Extract the ZIP.
4. Open a terminal in the folder containing `package.json`.
5. Run `npm install`.
6. Copy `apps/server/.env.example` to `apps/server/.env` and configure MongoDB + secrets.
7. Copy `apps/web/.env.example` to `apps/web/.env.local`.
8. Run `npm run db:setup`.
9. Run `npm run dev:server` in Terminal 1.
10. Run `npm run dev:web` in Terminal 2.
11. Open `http://localhost:3000`.

That is all that is needed for the normal local-development setup.
