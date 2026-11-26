# Athenaeum — Digital Library, Circulation Engine & Admin Console

Full-stack **Spring Boot** digital library platform located in [`library-app/`](./library-app/README.md), featuring:

- **Editorial Reader & Member Portal** (`/`, `/books`, `/books/{id}`, `/authors`, `/authors/{id}`, `/my-library`) with dark/light theme, live copy availability, borrowing, renewals, reading lists, and reader reviews.
- **Dedicated RBAC Admin Console** (`/admin/login`, `/admin`, `/admin/books`, `/admin/authors`, `/admin/loans`, `/admin/members`, `/admin/audit`) with **Chart.js** analytics, manual loan issuance, overdue fine settlement, member tier/role management, and audit logs.
- **Custom JPQL Inner Join Explorer** (`/books/joined`, `/authors/with-books`), **REST API** (`/health`, `/api/books`, `/api/authors`, `/api/stats`), and **CSV Export** (`/api/books/export.csv`).
- **43 Automated Tests** (JUnit 5, Mockito, `@DataJpaTest`, MockMvc RBAC integration tests) and multi-stage **Docker + Render** deployment (`render.yaml`).

See [`library-app/README.md`](./library-app/README.md) for complete documentation, demo credentials, and local setup instructions.

