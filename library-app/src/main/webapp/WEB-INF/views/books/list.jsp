<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Books Catalog — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="page-top">
            <div>
                <h1 class="page-title">Books Catalog</h1>
                <p class="page-sub">${books.size()} title(s) · ${stats.availableCopies} copies currently on shelf</p>
            </div>
            <div style="display:flex; gap:8px;">
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=grid"
                   class="btn btn-sm ${viewMode != 'table' ? 'btn-dark' : 'btn-secondary'}">Covers</a>
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=table"
                   class="btn btn-sm ${viewMode == 'table' ? 'btn-dark' : 'btn-secondary'}">List</a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <!-- Clean Underlined Genre Bar -->
        <nav class="category-bar" style="margin-bottom:1.25rem;">
            <a href="${pageContext.request.contextPath}/books?availability=${selectedAvailability}&sort=${selectedSort}&view=${viewMode}"
               class="${selectedGenre == 'ALL' ? 'active' : ''}">All</a>
            <c:forEach var="g" items="${genres}">
                <a href="${pageContext.request.contextPath}/books?genre=${g}&availability=${selectedAvailability}&sort=${selectedSort}&view=${viewMode}"
                   class="${selectedGenre == g ? 'active' : ''}">${g}</a>
            </c:forEach>
        </nav>

        <!-- Compact Filter Controls -->
        <form action="${pageContext.request.contextPath}/books" method="get" class="filter-strip">
            <input type="text" name="q" value="${query}" class="input" style="flex:1 1 240px;" placeholder="Filter by title, author, or ISBN...">
            <input type="hidden" name="genre" value="${selectedGenre}">
            <select name="availability" class="select" onchange="this.form.submit()">
                <option value="ALL" ${selectedAvailability == 'ALL' ? 'selected' : ''}>All availability</option>
                <option value="AVAILABLE" ${selectedAvailability == 'AVAILABLE' ? 'selected' : ''}>Available now</option>
                <option value="UNAVAILABLE" ${selectedAvailability == 'UNAVAILABLE' ? 'selected' : ''}>Waitlist only</option>
            </select>
            <select name="sort" class="select" onchange="this.form.submit()">
                <option value="rating" ${selectedSort == 'rating' ? 'selected' : ''}>Highest rated</option>
                <option value="title" ${selectedSort == 'title' ? 'selected' : ''}>Title A–Z</option>
                <option value="pages_asc" ${selectedSort == 'pages_asc' ? 'selected' : ''}>Shortest first</option>
                <option value="year_desc" ${selectedSort == 'year_desc' ? 'selected' : ''}>Newest first</option>
                <option value="year_asc" ${selectedSort == 'year_asc' ? 'selected' : ''}>Oldest first</option>
            </select>
            <input type="hidden" name="view" value="${viewMode}">
            <button type="submit" class="btn btn-primary btn-sm">Apply</button>
            <c:if test="${not empty query || selectedGenre != 'ALL' || selectedAvailability != 'ALL'}">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-ghost btn-sm">Clear</a>
            </c:if>
        </form>

        <c:choose>
            <c:when test="${empty books}">
                <div class="empty-state">
                    <h3>No books match your filters</h3>
                    <p style="margin-bottom:1rem;">Try a different keyword or clear the active filters.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">Reset filters</a>
                </div>
            </c:when>

            <c:when test="${viewMode == 'table'}">
                <div class="panel" style="padding:0;">
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Author</th>
                                    <th>Genre</th>
                                    <th>Format &amp; Shelf</th>
                                    <th>Status</th>
                                    <th>Rating</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${books}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/${book.id}" style="font-weight:600;">${book.title}</a>
                                            <div style="font-size:0.76rem; color:var(--ink-3);">${book.publishedYear} · ${book.pages} pages</div>
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/authors/${book.author.id}" class="header-link">${book.author.name}</a></td>
                                        <td><span class="tag">${book.genre}</span></td>
                                        <td style="font-size:0.82rem; color:var(--ink-2);">${book.formatLabel} · <span class="mono">${book.shelfLocation}</span></td>
                                        <td>
                                            <span class="tag ${book.available ? 'tag-green' : 'tag-amber'}">
                                                ${book.available ? book.availableCopies : 0}/${book.totalCopies} ${book.available ? 'available' : 'waitlist'}
                                            </span>
                                        </td>
                                        <td class="mono">${book.rating} ★</td>
                                        <td style="text-align:right; white-space:nowrap;">
                                            <button type="button" class="btn btn-ghost btn-sm" onclick="openReaderPreview(${book.id})">Notes</button>
                                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-secondary btn-sm">Open</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="shelf-grid">
                    <c:forEach var="book" items="${books}">
                        <article class="book-item">
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-cover-frame" style="background:${book.coverColor};">
                                <c:if test="${not empty book.resolvedCoverUrl}">
                                    <img class="book-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" loading="lazy" onerror="this.style.display='none'">
                                </c:if>
                                <div class="book-cover-fallback">
                                    <span class="book-cover-fallback-genre">${book.genre}</span>
                                    <div>
                                        <div class="book-cover-fallback-title">${book.title}</div>
                                        <div class="book-cover-fallback-author">${book.author.name}</div>
                                    </div>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-item-title">${book.title}</a>
                            <div class="book-item-author">${book.author.name}</div>
                            <div class="book-item-status">
                                <span class="status-dot ${book.available ? 'avail' : 'wait'}">
                                    ${book.available ? book.availableCopies : 'Waitlist'}${book.available ? ' on shelf' : ''}
                                </span>
                                <span class="mono">${book.rating} ★</span>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
