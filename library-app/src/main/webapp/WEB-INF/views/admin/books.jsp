<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Books &amp; Stock — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Books &amp; Stock (${books.size()})</h1>
        <p class="page-sub">Adjust shelf inventory, toggle Staff Picks, or edit catalog records</p>
    </div>
    <div style="display:flex; gap:8px;">
        <a href="${pageContext.request.contextPath}/api/books/export.csv" class="btn btn-secondary btn-sm">Export CSV</a>
        <a href="${pageContext.request.contextPath}/admin/books/new" class="btn btn-primary btn-sm">Add book</a>
    </div>
</div>

<form action="${pageContext.request.contextPath}/admin/books" method="get" class="filter-strip">
    <input type="text" name="q" value="${query}" class="input" style="flex:1 1 240px;" placeholder="Search title, ISBN, or author...">
    <select name="genre" class="select" onchange="this.form.submit()">
        <option value="ALL" ${selectedGenre == 'ALL' ? 'selected' : ''}>All genres</option>
        <c:forEach var="g" items="${genres}">
            <option value="${g}" ${selectedGenre == g ? 'selected' : ''}>${g}</option>
        </c:forEach>
    </select>
    <button type="submit" class="btn btn-secondary btn-sm">Filter</button>
</form>

<div class="panel" style="padding:0;">
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Shelf &amp; Format</th>
                    <th>Stock</th>
                    <th>Featured</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${books}">
                    <tr>
                        <td>
                            <div style="font-weight:600;">${book.title}</div>
                            <div class="mono" style="font-size:0.74rem; color:var(--ink-3);">${book.genre} · ${book.isbn}</div>
                        </td>
                        <td>${book.author.name}</td>
                        <td>
                            <span class="mono" style="font-size:0.82rem;">${book.shelfLocation}</span>
                            <span style="font-size:0.76rem; color:var(--ink-3);"> · ${book.formatLabel}</span>
                        </td>
                        <td>
                            <div style="display:flex; align-items:center; gap:5px;">
                                <form action="${pageContext.request.contextPath}/admin/books/stock/${book.id}" method="post">
                                    <input type="hidden" name="delta" value="-1">
                                    <button type="submit" class="btn btn-secondary btn-sm" style="padding:3px 8px;">−</button>
                                </form>
                                <span class="tag ${book.available ? 'tag-green' : 'tag-red'} mono">${book.availableCopies}/${book.totalCopies}</span>
                                <form action="${pageContext.request.contextPath}/admin/books/stock/${book.id}" method="post">
                                    <input type="hidden" name="delta" value="1">
                                    <button type="submit" class="btn btn-secondary btn-sm" style="padding:3px 8px;">+</button>
                                </form>
                            </div>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/books/feature/${book.id}" method="post">
                                <button type="submit" class="btn btn-sm ${book.featured ? 'btn-dark' : 'btn-secondary'}">
                                    ${book.featured ? 'Featured' : 'Standard'}
                                </button>
                            </form>
                        </td>
                        <td style="text-align:right; white-space:nowrap;">
                            <a href="${pageContext.request.contextPath}/admin/books/edit/${book.id}" class="btn btn-secondary btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/books/delete/${book.id}" method="post" style="display:inline;"
                                  onsubmit="return confirm('Delete this book and all linked loan/hold records?')">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>
