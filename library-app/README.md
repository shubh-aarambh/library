# Athenaeum — Digital Library, Circulation Engine & Admin Console

A production-ready full-stack **Spring Boot** digital library platform featuring a modern **Reader & Member Portal**, a dedicated **RBAC Admin Control Plane (`/admin`)**, live inventory & loan circulation, overdue fine calculation, reader reviews, reading lists, custom JPQL inner-join explorer, JSON REST API, CSV export, and Docker/Render deployment.

---

## Key Features

### Public & Member Reader Portal
- **Editorial Dark/Light Theme UI** — Responsive literary glassmorphism interface with custom typographic hardcover book jackets, instant dark/light theme persistence, and `/` quick-search shortcut.
- **Interactive Catalog (`/books`)** — Search by title/author/genre/ISBN, filter by genre & copy availability, sort by rating/year/availability, and switch between Grid & Table views.
- **Book Detail & Circulation (`/books/{id}`)** — Live copy availability progress bar, 1-click self-service checkout (7/14/21 days), Reading List bookmarking, and verified reader reviews with dynamic rating recalculation.
- **Authors Directory & Profiles (`/authors`, `/authors/{id}`)** — Search, nationality filtering, JPQL Inner Join "Authors with Books" view, notable honors, and full author bibliographies.
- **Member Self-Service Dashboard (`/my-library`)** — Active borrowings with days remaining, +7-day loan renewals, 1-click returns, personal Reading List, and borrowing history.
- **JPQL Inner Join Explorer (`/books/joined`)** — Live relational query explorer combining `Book` and `Author` entities with row filtering and CSV export.

### Dedicated Admin Site (`/admin`)
- **RBAC-Protected Sidebar Console (`/admin/login`)** — PBKDF2-salted authentication with role-based route protection (`AuthInterceptor`) and 1-click portfolio demo login.
- **Analytics Dashboard (`/admin`)** — Live KPI telemetry cards, interactive **Chart.js** Genre Distribution Doughnut & Loan Lifecycle Bar charts, recent loans table, and real-time audit stream.
- **Inventory & Authors Management (`/admin/books`, `/admin/authors`)** — Full CRUD, copy stock tracking, homepage Staff Picks toggle, and cascade-safe deletion.
- **Circulation & Loans Desk (`/admin/loans`)** — Manual loan issuance, status filters (`ALL`, `ACTIVE`, `OVERDUE`, `RETURNED`), book check-in, +7-day renewals, automatic overdue detection, and fine settlement (`$1.50/day`).
- **Member Directory & Roles (`/admin/members`)** — Promote/demote roles (`MEMBER` / `ADMIN`), manage tiers (`STANDARD`, `SCHOLAR`, `VIP`) with borrow quotas, and suspend/activate accounts.
- **System Audit Trail (`/admin/audit`)** — Category-filtered chronological ledger of catalog, circulation, member, and system events.

### REST API & Operations
- `GET /health` — Service health & live telemetry JSON (used for Render health checks)
- `GET /api/books` — JSON book catalog
- `GET /api/authors` — JSON authors directory
- `GET /api/stats` — Aggregated inventory, circulation & genre analytics JSON
- `GET /api/books/export.csv` — Instant CSV catalog download
- `/h2-console` — Built-in H2 database inspector

---

## Demo Accounts (Pre-Seeded)

| Portal | Email | Password | Role / Tier |
|---|---|---|---|
| **Admin Console** (`/admin/login`) | `admin@library.dev` | `admin123` | `ADMIN` · VIP |
| **Member Portal** (`/login`) | `reader@library.dev` | `reader123` | `MEMBER` · Scholar |

Both login screens include **1-Click Demo Sign-In** buttons for instant exploration.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java 11+ · Spring Boot 2.7.18 · Spring Web MVC |
| Persistence | Spring Data JPA · Hibernate · Custom JPQL Inner Joins · H2 |
| Security | Salted PBKDF2-HMAC-SHA256 Password Hashing · Session RBAC Interceptor |
| Frontend | JSP + JSTL + Spring Form Tags · Custom CSS Design System · Chart.js 4 |
| Testing | JUnit 5 · Mockito · Spring Boot Test · MockMvc · `@DataJpaTest` |
| Deployment | Multi-stage Docker (`maven` → `eclipse-temurin:17-jre-alpine`) · Render Blueprint (`render.yaml`) |

---

## Quick Start

```bash
# Run locally with Maven
./mvnw spring-boot:run

# Run full test suite (43+ unit, repository & MockMvc RBAC tests)
./mvnw test

# Build executable WAR & run
./mvnw clean package
java -jar target/library.war
```

Open **http://localhost:8080** (Public Site) or **http://localhost:8080/admin** (Admin Console).

---

## Author

**Shubh Shukla** — Full-Stack & Cloud-Native Systems Engineer
