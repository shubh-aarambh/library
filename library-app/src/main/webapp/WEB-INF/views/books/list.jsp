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
                <div class="section-kicker">Interactive Collection</div>
                <h1 class="section-title">Book Catalog</h1>
                <p class="section-subtitle">Showing ${books.size()} volume(s) · ${stats.availableCopies} copies currently on shelf</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/api/books/export.csv" class="btn btn-secondary btn-sm">Export CSV</a>
                <a href="${pageContext.request.contextPath}/books/joined" class="btn btn-secondary btn-sm">JPQL Join View</a>
                <a href="${pageContext.request.contextPath}/books/new" class="btn btn-primary btn-sm">+ Add Book</a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
        </c:if>

        <!-- Search, Filter, Sort & View Mode Bar -->
        <form action="${pageContext.request.contextPath}/books" method="get" class="filter-bar">
            <div class="filter-search">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" name="q" value="${query}" data-quick-search placeholder="Search title, author, genre, or ISBN... (press /)">
            </div>

            <select name="genre" class="filter-select" onchange="this.form.submit()">
                <option value="ALL" ${selectedGenre == 'ALL' ? 'selected' : ''}>All Genres</option>
                <c:forEach var="g" items="${genres}">
                    <option value="${g}" ${selectedGenre == g ? 'selected' : ''}>${g}</option>
                </c:forEach>
            </select>

            <select name="availability" class="filter-select" onchange="this.form.submit()">
                <option value="ALL" ${selectedAvailability == 'ALL' ? 'selected' : ''}>Any Availability</option>
                <option value="AVAILABLE" ${selectedAvailability == 'AVAILABLE' ? 'selected' : ''}>Available Now</option>
                <option value="UNAVAILABLE" ${selectedAvailability == 'UNAVAILABLE' ? 'selected' : ''}>Checked Out</option>
            </select>

            <select name="sort" class="filter-select" onchange="this.form.submit()">
                <option value="title" ${selectedSort == 'title' ? 'selected' : ''}>Sort: Title (A–Z)</option>
                <option value="rating" ${selectedSort == 'rating' ? 'selected' : ''}>Sort: Top Rated</option>
                <option value="year_desc" ${selectedSort == 'year_desc' ? 'selected' : ''}>Sort: Newest Year</option>
                <option value="year_asc" ${selectedSort == 'year_asc' ? 'selected' : ''}>Sort: Oldest Classic</option>
                <option value="available" ${selectedSort == 'available' ? 'selected' : ''}>Sort: Most Available</option>
            </select>

            <input type="hidden" name="view" value="${viewMode}">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>

            <div style="display:flex; gap:6px; margin-left:auto;">
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=grid"
                   class="btn btn-sm ${viewMode != 'table' ? 'btn-gold-outline' : 'btn-secondary'}">Grid</a>
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=table"
                   class="btn btn-sm ${viewMode == 'table' ? 'btn-gold-outline' : 'btn-secondary'}">Table</a>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty books}">
                <div class="card empty-state">
                    <h3>No Matching Books Found</h3>
                    <p style="margin-bottom:1.25rem;">Try clearing your search or switching genre filters.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Reset Filters</a>
                </div>
            </c:when>

            <c:when test="${viewMode == 'table'}">
                <div class="card" style="padding:0;">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title &amp; Shelf</th>
                                    <th>Author</th>
                                    <th>Genre</th>
                                    <th>Year</th>
                                    <th>Copies</th>
                                    <th>Rating</th>
                                    <th>ISBN</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${books}" varStatus="status">
                                    <tr>
                                        <td class="mono" style="color:var(--text-muted);">${status.count}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/${book.id}" style="font-weight:700; color:var(--text);">${book.title}</a>
                                            <div class="mono" style="font-size:0.74rem; color:var(--text-muted);">Shelf ${book.shelfLocation} · ${book.pages}p</div>
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="color:var(--gold); font-weight:600;">${book.author.name}</a></td>
                                        <td><span class="badge">${book.genre}</span></td>
                                        <td>${book.publishedYear}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${book.available}">
                                                    <span class="badge badge-emerald">${book.availableCopies}/${book.totalCopies}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">0/${book.totalCopies}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:var(--gold); font-weight:700;">★ ${book.rating}</td>
                                        <td class="mono" style="font-size:0.76rem; color:var(--text-muted);">${book.isbn}</td>
                                        <td>
                                            <div style="display:flex; gap:6px;">
                                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-gold-outline btn-sm">View</a>
                                                <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-secondary btn-sm">Edit</a>
                                                <a href="${pageContext.request.contextPath}/books/delete/${book.id}" class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Delete this book from catalog?')">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="books-grid">
                    <c:forEach var="book" items="${books}">
                        <article class="book-card">
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-cover" style="background:${book.coverColor};">
                                <div class="book-cover-top">
                                    <span class="cover-genre">${book.genre}</span>
                                    <span class="cover-rating">★ ${book.rating}</span>
                                </div>
                                <div>
                                    <div class="book-cover-title">${book.title}</div>
                                    <div class="book-cover-author">${book.author.name} · ${book.publishedYear}</div>
                                </div>
                            </a>
                            <div class="book-body">
                                <p class="book-desc">${book.description}</p>
                                <div>
                                    <div style="display:flex; justify-content:space-between; font-size:0.76rem; margin-bottom:5px;">
                                        <span class="mono" style="color:var(--text-muted);">Shelf ${book.shelfLocation}</span>
                                        <span style="font-weight:700; color:${book.available ? 'var(--emerald)' : 'var(--danger)'};">
                                            ${book.availableCopies} of ${book.totalCopies} available
                                        </span>
                                    </div>
                                    <div class="availability-bar">
                                        <div class="availability-fill" style="width:${book.availabilityPercent}%;"></div>
                                    </div>
                                </div>
                                <div class="book-actions">
                                    <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary btn-sm" style="flex:1;">View Details</a>
                                    <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-secondary btn-sm">Edit</a>
                                </div>
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
