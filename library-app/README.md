# 📚 Library Manager — Spring Boot Application

A full-stack Spring Boot web application to manage **Books** and **Authors** with complete CRUD operations, JPA relationships, custom JPQL inner-join queries, JSP views, and unit tests.

---

## 🚀 Features

- **Create** — Add new Authors and Books via HTML forms
- **Read** — View all Authors and Books in tabular format; Inner Join view combining both entities
- **Update** — Edit existing Author/Book details with pre-populated forms
- **Delete** — Remove Authors (cascades to Books) or individual Books
- **Exception Handling** — Global handler for duplicate ISBN (`DataIntegrityViolationException`) and missing records (`ResourceNotFoundException`)
- **Database Seeding** — Auto-populates 10 Authors and 10 Books on first startup
- **H2 Console** — In-browser database inspector at `/h2-console`

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Spring Boot 2.7.18 |
| ORM | Spring Data JPA / Hibernate |
| Database | H2 (in-memory) |
| View | JSP + JSTL + Spring Form Tags |
| Validation | Bean Validation (javax.validation) |
| Testing | JUnit 5, Mockito, AssertJ |
| Build | Maven |
| Java | Java 11+ |

---

## 📐 Entity Relationship Design

```
┌─────────────────────┐          ┌──────────────────────────┐
│       Author        │  1    *  │          Book            │
├─────────────────────┤──────────├──────────────────────────┤
│ id (PK)             │          │ id (PK)                  │
│ name (NOT NULL)     │          │ title (NOT NULL)         │
│ nationality         │          │ genre (NOT NULL)         │
│ birthYear           │          │ publishedYear (NOT NULL) │
│ biography           │          │ isbn (UNIQUE, NOT NULL)  │
│                     │          │ description              │
│                     │          │ author_id (FK)           │
└─────────────────────┘          └──────────────────────────┘
```

- `Author` has **@OneToMany** → `books` (cascade ALL, fetch LAZY)
- `Book` has **@ManyToOne** → `author` (NOT NULL, FK constraint)

---

## 🗂️ Project Structure

```
library-app/
├── pom.xml
└── src/
    ├── main/
    │   ├── java/com/library/
    │   │   ├── LibraryApplication.java         # Entry point
    │   │   ├── DataInitializer.java             # Seeds 10 authors + 10 books
    │   │   ├── model/
    │   │   │   ├── Author.java                  # JPA Entity
    │   │   │   └── Book.java                    # JPA Entity
    │   │   ├── repository/
    │   │   │   ├── AuthorRepository.java        # Custom JPQL queries
    │   │   │   └── BookRepository.java          # Custom JPQL inner-join query
    │   │   ├── service/
    │   │   │   ├── AuthorService.java           # Interface
    │   │   │   ├── BookService.java             # Interface
    │   │   │   └── impl/
    │   │   │       ├── AuthorServiceImpl.java
    │   │   │       └── BookServiceImpl.java
    │   │   ├── controller/
    │   │   │   ├── HomeController.java
    │   │   │   ├── AuthorController.java        # /authors CRUD
    │   │   │   └── BookController.java          # /books CRUD + joined view
    │   │   └── exception/
    │   │       ├── ResourceNotFoundException.java
    │   │       └── GlobalExceptionHandler.java  # @ControllerAdvice
    │   ├── resources/
    │   │   └── application.properties
    │   └── webapp/
    │       ├── static/css/styles.css            # Dark-themed CSS
    │       └── WEB-INF/views/
    │           ├── index.jsp
    │           ├── error.jsp
    │           ├── authors/
    │           │   ├── list.jsp
    │           │   └── form.jsp
    │           └── books/
    │               ├── list.jsp
    │               ├── form.jsp
    │               └── joinedView.jsp           # INNER JOIN result
    └── test/java/com/library/
        ├── repository/
        │   ├── AuthorRepositoryTest.java        # @DataJpaTest — 7 tests
        │   └── BookRepositoryTest.java          # @DataJpaTest — 9 tests
        └── service/
            ├── AuthorServiceTest.java           # Mockito — 8 tests
            └── BookServiceTest.java             # Mockito — 9 tests
```

---

## ⚡ Getting Started

### Prerequisites
- Java 11 or higher
- Maven (or IntelliJ IDEA with bundled Maven)

### Run the Application

```bash
# Using Maven Wrapper
./mvnw spring-boot:run

# Or using system Maven
mvn spring-boot:run
```

The application starts on **http://localhost:8080**

### Run Tests

```bash
mvn test
```

Expected output: **Tests run: 33, Failures: 0, Errors: 0, Skipped: 0**

---

## 🌐 Application URLs

| URL | Description |
|---|---|
| `http://localhost:8080/` | Home page |
| `http://localhost:8080/authors` | List all authors |
| `http://localhost:8080/authors/new` | Add a new author |
| `http://localhost:8080/authors/edit/{id}` | Edit an author |
| `http://localhost:8080/books` | List all books |
| `http://localhost:8080/books/new` | Add a new book |
| `http://localhost:8080/books/edit/{id}` | Edit a book |
| `http://localhost:8080/books/joined` | Inner Join view (Books + Authors) |
| `http://localhost:8080/h2-console` | H2 Database Console |

**H2 Console settings:**
- JDBC URL: `jdbc:h2:mem:librarydb`
- Username: `sa`
- Password: *(leave blank)*

---

## 🔗 Custom Repository Queries (Inner Join)

### BookRepository — Books with Author Details
```java
@Query("SELECT b.title, b.genre, b.isbn, b.publishedYear, a.name " +
       "FROM Book b INNER JOIN b.author a " +
       "ORDER BY a.name, b.title")
List<Object[]> findAllBooksWithAuthorDetails();
```

### AuthorRepository — Authors With At Least One Book
```java
@Query("SELECT DISTINCT a FROM Author a INNER JOIN a.books b")
List<Author> findAuthorsWithAtLeastOneBook();
```

---

## 🧪 Test Coverage

| Test Class | Type | Tests |
|---|---|---|
| `AuthorRepositoryTest` | `@DataJpaTest` (real H2) | 7 |
| `BookRepositoryTest` | `@DataJpaTest` (real H2) | 9 |
| `AuthorServiceTest` | Mockito unit test | 8 |
| `BookServiceTest` | Mockito unit test | 9 |
| **Total** | | **33 ✅** |

---

## 📦 Sample Seeded Data

**Authors:** J.R.R. Tolkien, George Orwell, J.K. Rowling, Albert Camus, Jane Austen, Franz Kafka, F. Scott Fitzgerald, Toni Morrison, Gabriel García Márquez, Fyodor Dostoevsky

**Books:** The Fellowship of the Ring, Nineteen Eighty-Four, Harry Potter and the Philosopher's Stone, The Stranger, Pride and Prejudice, The Metamorphosis, The Great Gatsby, Beloved, One Hundred Years of Solitude, Crime and Punishment

---

## 🙋 Author

**Shubh** — DB BITS Assignment Q1  
Spring Boot | JPA | JSP | JUnit | Mockito
