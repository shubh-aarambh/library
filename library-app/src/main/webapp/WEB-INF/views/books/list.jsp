<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${pageTitle} — Library Manager</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
        </head>

        <body>

            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <span class="brand-icon">📚</span>
                    <span>Library Manager</span>
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/authors">👤 Authors</a></li>
                    <li><a href="${pageContext.request.contextPath}/authors/new">➕ Add Author</a></li>
                    <li><a href="${pageContext.request.contextPath}/books" class="active">📖 Books</a></li>
                    <li><a href="${pageContext.request.contextPath}/books/new">➕ Add Book</a></li>
                    <li><a href="${pageContext.request.contextPath}/books/joined">🔗 Joined View</a></li>
                </ul>
            </nav>

            <div class="container">
                <div class="page-header">
                    <div>
                        <h1>${pageTitle}</h1>
                        <p class="page-subtitle">Browse and manage the book catalogue</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/books/new" class="btn btn-primary">➕ Add Book</a>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">✅ ${successMessage}</div>
                </c:if>

                <div class="stats-bar">
                    <span class="stat-chip">📖 ${books.size()} Book(s) Found</span>
                    <a href="${pageContext.request.contextPath}/books/joined" class="stat-chip"
                        style="text-decoration:none; cursor:pointer;">🔗 View Inner Join</a>
                </div>

                <div class="card">
                    <c:choose>
                        <c:when test="${empty books}">
                            <div class="empty-state">
                                <div class="empty-state-icon">📖</div>
                                <h3>No Books Found</h3>
                                <p>Start by adding your first book.</p>
                                <a href="${pageContext.request.contextPath}/books/new" class="btn btn-primary"
                                    style="margin-top:1rem">➕ Add Book</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Title</th>
                                            <th>Genre</th>
                                            <th>Author</th>
                                            <th>Year</th>
                                            <th>ISBN</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="book" items="${books}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td><strong>${book.title}</strong></td>
                                                <td><span class="badge">${book.genre}</span></td>
                                                <td>${book.author.name}</td>
                                                <td>${book.publishedYear}</td>
                                                <td style="font-size:0.8rem; color:var(--muted);">${book.isbn}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/books/edit/${book.id}"
                                                        class="btn btn-secondary btn-sm">✏️ Edit</a>
                                                    <a href="${pageContext.request.contextPath}/books/delete/${book.id}"
                                                        class="btn btn-danger btn-sm" onclick="return confirm('Delete \"
                                                        ${book.title}\"?')">🗑️ Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </body>

        </html>