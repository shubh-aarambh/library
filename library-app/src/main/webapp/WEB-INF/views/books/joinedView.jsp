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
                    <li><a href="${pageContext.request.contextPath}/books">📖 Books</a></li>
                    <li><a href="${pageContext.request.contextPath}/books/joined" class="active">🔗 Joined View</a></li>
                </ul>
            </nav>

            <div class="container">
                <div class="page-header">
                    <div>
                        <h1>🔗 Books + Authors — Inner Join</h1>
                        <p class="page-subtitle">JPQL: <code
                                style="color:var(--gold)">SELECT b.title, b.genre, b.isbn, b.publishedYear, a.name FROM Book b INNER JOIN b.author a</code>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">← Back to Books</a>
                </div>

                <div class="stats-bar">
                    <span class="stat-chip">🔗 ${rows.size()} Records from Inner Join</span>
                </div>

                <div class="card">
                    <c:choose>
                        <c:when test="${empty rows}">
                            <div class="empty-state">
                                <div class="empty-state-icon">🔗</div>
                                <h3>No Results</h3>
                                <p>No books are linked to any author yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Book Title</th>
                                            <th>Genre</th>
                                            <th>ISBN</th>
                                            <th>Published Year</th>
                                            <th>Author Name</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="row" items="${rows}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td><strong>${row[0]}</strong></td>
                                                <td><span class="badge">${row[1]}</span></td>
                                                <td style="font-size:0.8rem; color:var(--muted);">${row[2]}</td>
                                                <td>${row[3]}</td>
                                                <td>👤 ${row[4]}</td>
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