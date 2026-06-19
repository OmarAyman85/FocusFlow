# FocusFlow

A Trello-style task management app: boards, lists, and cards with per-board
membership roles (owner / admin / member / viewer) and public/private board
visibility. Backend is Express + MySQL (Sequelize); frontend is Angular
(standalone components) + Tailwind CSS.

The `mobile/` Flutter app is a separate, unrelated project and is not covered
by this README.

## Stack

- **Backend**: Express, Sequelize, MySQL, JWT auth (`backend/`)
- **Frontend**: Angular 22 (standalone, zoneless), Tailwind CSS, Angular CDK drag-and-drop (`frontend/`)

## Local setup

### 1. Database

Run MySQL locally, then create the database and a dedicated app user:

```sql
CREATE DATABASE IF NOT EXISTS focusflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'focusflow'@'localhost' IDENTIFIED BY '<your-password>';
GRANT ALL PRIVILEGES ON focusflow.* TO 'focusflow'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Backend

```
cd backend
npm install
```

Create `backend/.env`:

```
PORT=5000
NODE_ENV=development
JWT_SECRET=<random-secret>

DB_HOST=localhost
DB_PORT=3306
DB_USER=focusflow
DB_PASSWORD=<your-password>
DB_NAME=focusflow

CORS_ORIGIN=http://localhost:4200
```

Run migrations (and optionally seed demo data):

```
npx sequelize-cli db:migrate
npx sequelize-cli db:seed:all
```

### 3. Frontend

```
cd frontend
npm install
```

The dev server proxies `/api` to `http://localhost:5000` (see
`frontend/proxy.conf.json`), so no separate API URL config is needed.

### 4. Run it

In one terminal:

```
cd backend && npm start
```

In another:

```
cd frontend && npm start
```

Backend runs on `:5000`, Angular dev server on `:4200`.

## Data model

`Board` → `BoardMember` (role: owner/admin/member/viewer) → `List` → `Card`.
A board is `private` (members only) or `public` (anyone with the link can
view read-only; joining grants `viewer` access, promotable by an owner/admin).

## Future enhancements (explicitly out of scope for now)

- Comments and an activity/audit log on cards
- File attachments
- Labels/tags
- Notifications
- Search
- Real-time sync (WebSockets/Socket.IO) — currently REST + refetch-on-action
- Multi-board workspaces
