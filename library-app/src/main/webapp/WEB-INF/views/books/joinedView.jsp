<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="section-header">
            <div>
                <div class="section-kicker">Spring Data JPA · Relational Query</div>
                <h1 class="section-title">Books × Authors Inner Join Explorer</h1>
                <p class="section-subtitle">Live JPQL projection joining the Books and Authors relational tables</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/api/books/export.csv" class="btn btn-gold-outline btn-sm">Download CSV</a>
                <a href="${pageContext.request.contextPath}/authors/with-books" class="btn btn-secondary btn-sm">Authors With Books Join</a>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">← Catalog</a>
            </div>
        </div>

        <div class="jpql-code-box">
            SELECT b.title, b.genre, b.isbn, b.publishedYear, a.name<br>
            FROM Book b INNER JOIN b.author a<br>
            ORDER BY a.name, b.title
        </div>

        <form action="${pageContext.request.contextPath}/books/joined" method="get" class="filter-bar">
            <div class="filter-search">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" name="q" value="${query}" data-quick-search placeholder="Filter joined rows by book title, genre, ISBN, or author...">
            </div>
            <button type="submit" class="btn btn-primary btn-sm">Filter Rows</button>
            <span class="badge badge-sky">${rows.size()} Joined Record(s)</span>
        </form>

        <div class="card" style="padding:0;">
            <c:choose>
                <c:when test="${empty rows}">
                    <div class="empty-state">
                        <h3>No Joined Results</h3>
                        <p>No records match your filter criteria.</p>
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
                                        <td class="mono" style="color:var(--text-muted);">${status.count}</td>
                                        <td><strong>${row[0]}</strong></td>
                                        <td><span class="badge">${row[1]}</span></td>
                                        <td class="mono" style="font-size:0.78rem; color:var(--text-muted);">${row[2]}</td>
                                        <td>${row[3]}</td>
                                        <td style="color:var(--gold); font-weight:600;">${row[4]}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
