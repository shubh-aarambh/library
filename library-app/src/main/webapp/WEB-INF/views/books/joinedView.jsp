<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Books + Authors Join — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="page-top">
            <div>
                <h1 class="page-title">Books &amp; Authors Inner Join</h1>
                <p class="page-sub">Live JPQL relational join projection across Books and Authors tables</p>
            </div>
            <div style="display:flex; gap:8px;">
                <a href="${pageContext.request.contextPath}/api/books/export.csv" class="btn btn-secondary btn-sm">Export CSV</a>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">← Books</a>
            </div>
        </div>

        <div class="jpql-code-box">SELECT b.title, b.genre, b.isbn, b.publishedYear, a.name FROM Book b INNER JOIN b.author a ORDER BY a.name, b.title</div>

        <form action="${pageContext.request.contextPath}/books/joined" method="get" class="filter-strip">
            <input type="text" name="q" value="${query}" class="input" style="flex:1 1 240px;" placeholder="Filter joined rows...">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <span class="tag">${rows.size()} rows</span>
        </form>

        <div class="panel" style="padding:0;">
            <div class="table-wrap">
                <table>
                    <thead><tr><th>#</th><th>Title</th><th>Genre</th><th>ISBN</th><th>Year</th><th>Author</th></tr></thead>
                    <tbody>
                        <c:forEach var="row" items="${rows}" varStatus="status">
                            <tr>
                                <td class="mono" style="color:var(--ink-3);">${status.count}</td>
                                <td><strong>${row[0]}</strong></td>
                                <td><span class="tag">${row[1]}</span></td>
                                <td class="mono" style="font-size:0.78rem; color:var(--ink-3);">${row[2]}</td>
                                <td>${row[3]}</td>
                                <td>${row[4]}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
