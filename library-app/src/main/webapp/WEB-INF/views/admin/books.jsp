<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Books — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">Books Inventory (${books.size()})</h1>
        <p class="section-subtitle">Manage catalog metadata, copy availability, and homepage staff picks</p>
    </div>
    <div style="display:flex; gap:10px;">
        <a href="${pageContext.request.contextPath}/api/books/export.csv" class="btn btn-secondary btn-sm">Export CSV</a>
        <a href="${pageContext.request.contextPath}/admin/books/new" class="btn btn-primary btn-sm">+ Add Volume</a>
    </div>
</div>

<form action="${pageContext.request.contextPath}/admin/books" method="get" class="filter-bar">
    <div class="filter-search">
        <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <input type="text" name="q" value="${query}" data-quick-search placeholder="Search title, ISBN, or author...">
    </div>
    <select name="genre" class="filter-select" onchange="this.form.submit()">
        <option value="ALL" ${selectedGenre == 'ALL' ? 'selected' : ''}>All Genres</option>
        <c:forEach var="g" items="${genres}">
            <option value="${g}" ${selectedGenre == g ? 'selected' : ''}>${g}</option>
        </c:forEach>
    </select>
    <button type="submit" class="btn btn-primary btn-sm">Search</button>
</form>

<div class="card" style="padding:0;">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Volume</th>
                    <th>Author</th>
                    <th>Genre</th>
                    <th>Shelf</th>
                    <th>Inventory</th>
                    <th>Staff Pick</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${books}">
                    <tr>
                        <td>
                            <div style="font-weight:700;">${book.title}</div>
                            <div class="mono" style="font-size:0.74rem; color:var(--text-muted);">${book.isbn} · ${book.publishedYear}</div>
                        </td>
                        <td>${book.author.name}</td>
                        <td><span class="badge">${book.genre}</span></td>
                        <td class="mono">${book.shelfLocation}</td>
                        <td>
                            <span class="badge ${book.available ? 'badge-emerald' : 'badge-danger'}">
                                ${book.availableCopies} / ${book.totalCopies} avail
                            </span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/books/feature/${book.id}" method="post">
                                <button type="submit" class="btn btn-sm ${book.featured ? 'btn-gold-outline' : 'btn-secondary'}">
                                    ${book.featured ? '★ Featured' : '☆ Feature'}
                                </button>
                            </form>
                        </td>
                        <td>
                            <div style="display:flex; gap:6px;">
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-secondary btn-sm" target="_blank">View</a>
                                <a href="${pageContext.request.contextPath}/admin/books/edit/${book.id}" class="btn btn-gold-outline btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/books/delete/${book.id}" method="post"
                                      onsubmit="return confirm('Delete this book and all its loan/review records?')">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </div>
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

