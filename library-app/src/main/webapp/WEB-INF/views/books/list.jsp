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
                <div class="section-kicker">Browse Collection</div>
                <h1 class="section-title">Library Catalog</h1>
                <p class="section-subtitle">${books.size()} title(s) shown · ${stats.availableCopies} shelf copies ready to borrow today</p>
            </div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="openSpotlight()">Quick Search (⌘K)</button>
                <c:if test="${not empty currentUser && currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-dark btn-sm">Manage in Admin →</a>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
        </c:if>

        <!-- Genre Quick Pills -->
        <div class="genre-pills">
            <a href="${pageContext.request.contextPath}/books?availability=${selectedAvailability}&sort=${selectedSort}&view=${viewMode}"
               class="genre-pill ${selectedGenre == 'ALL' ? 'active' : ''}">All Genres</a>
            <c:forEach var="g" items="${genres}">
                <a href="${pageContext.request.contextPath}/books?genre=${g}&availability=${selectedAvailability}&sort=${selectedSort}&view=${viewMode}"
                   class="genre-pill ${selectedGenre == g ? 'active' : ''}">${g}</a>
            </c:forEach>
        </div>

        <!-- Search, Availability, Sort & View Mode -->
        <form action="${pageContext.request.contextPath}/books" method="get" class="filter-bar">
            <div class="filter-search">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" name="q" value="${query}" placeholder="Filter by title, author, genre, or ISBN...">
            </div>

            <input type="hidden" name="genre" value="${selectedGenre}">
            <select name="availability" class="filter-select" onchange="this.form.submit()">
                <option value="ALL" ${selectedAvailability == 'ALL' ? 'selected' : ''}>All Statuses</option>
                <option value="AVAILABLE" ${selectedAvailability == 'AVAILABLE' ? 'selected' : ''}>Available Now</option>
                <option value="UNAVAILABLE" ${selectedAvailability == 'UNAVAILABLE' ? 'selected' : ''}>Waitlist Only</option>
            </select>

            <select name="sort" class="filter-select" onchange="this.form.submit()">
                <option value="rating" ${selectedSort == 'rating' ? 'selected' : ''}>Sort: Top Rated</option>
                <option value="title" ${selectedSort == 'title' ? 'selected' : ''}>Sort: Title (A–Z)</option>
                <option value="pages_asc" ${selectedSort == 'pages_asc' ? 'selected' : ''}>Sort: Shortest Read</option>
                <option value="year_desc" ${selectedSort == 'year_desc' ? 'selected' : ''}>Sort: Newest</option>
                <option value="year_asc" ${selectedSort == 'year_asc' ? 'selected' : ''}>Sort: Classic First</option>
            </select>

            <input type="hidden" name="view" value="${viewMode}">
            <button type="submit" class="btn btn-primary btn-sm">Apply</button>

            <div style="display:flex; gap:6px; margin-left:auto;">
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=grid"
                   class="btn btn-sm ${viewMode != 'table' ? 'btn-dark' : 'btn-secondary'}">Covers</a>
                <a href="${pageContext.request.contextPath}/books?q=${query}&genre=${selectedGenre}&availability=${selectedAvailability}&sort=${selectedSort}&view=table"
                   class="btn btn-sm ${viewMode == 'table' ? 'btn-dark' : 'btn-secondary'}">List</a>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty books}">
                <div class="card empty-state">
                    <h3>No Matching Books Found</h3>
                    <p style="margin-bottom:1.25rem;">Try broadening your search or switching availability filters.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Reset Filters</a>
                </div>
            </c:when>

            <c:when test="${viewMode == 'table'}">
                <div class="card" style="padding:0;">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>Book</th>
                                    <th>Author</th>
                                    <th>Genre &amp; Format</th>
                                    <th>Length</th>
                                    <th>Shelf Status</th>
                                    <th>Rating</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${books}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/${book.id}" style="font-weight:700; color:var(--text);">${book.title}</a>
                                            <div class="mono" style="font-size:0.74rem; color:var(--text-muted);">Shelf ${book.shelfLocation} · ${book.publishedYear}</div>
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="color:var(--accent); font-weight:600;">${book.author.name}</a></td>
                                        <td>
                                            <span class="badge badge-neutral">${book.genre}</span>
                                            <span style="font-size:0.74rem; color:var(--text-muted); margin-left:4px;">${book.formatLabel}</span>
                                        </td>
                                        <td style="font-size:0.83rem; color:var(--text-soft);">${book.pages}p · ${book.formattedReadingTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${book.available}">
                                                    <span class="badge badge-emerald">${book.availableCopies}/${book.totalCopies} On Shelf</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge">Waitlist Open</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:var(--accent); font-weight:700;">★ ${book.rating}</td>
                                        <td>
                                            <div style="display:flex; gap:6px;">
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${book.id})">Preview</button>
                                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn ${book.available ? 'btn-primary' : 'btn-gold-outline'} btn-sm">
                                                    ${book.available ? 'Borrow' : 'Waitlist'}
                                                </a>
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
                        <article class="book-tile">
                            <div class="book-tile-cover-wrap">
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="real-cover" style="background:${book.coverColor};">
                                    <c:if test="${not empty book.resolvedCoverUrl}">
                                        <img class="real-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" loading="lazy" onerror="this.style.display='none'">
                                    </c:if>
                                    <span class="cover-ribbon ${book.available ? 'avail' : 'waitlist'}">
                                        ${book.available ? book.availableCopies : 'Waitlist'}${book.available ? ' avail' : ''}
                                    </span>
                                    <div class="cover-fallback">
                                        <span style="font-size:0.7rem; text-transform:uppercase; letter-spacing:0.1em; opacity:0.8;">${book.genre}</span>
                                        <div>
                                            <div class="cover-fallback-title">${book.title}</div>
                                            <div class="cover-fallback-author">${book.author.name}</div>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <div class="book-tile-meta">
                                <span>${book.genre} · ${book.formattedReadingTime}</span>
                                <span style="color:var(--accent);">★ ${book.rating}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-tile-title">${book.title}</a>
                            <div class="book-tile-author">by <a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="text-decoration:underline; text-underline-offset:3px;">${book.author.name}</a></div>

                            <div style="margin-bottom:0.75rem;">
                                <div style="display:flex; justify-content:space-between; font-size:0.74rem; margin-bottom:4px; color:var(--text-muted);">
                                    <span>${book.formatLabel} · Shelf ${book.shelfLocation}</span>
                                    <span style="font-weight:700; color:${book.available ? 'var(--emerald)' : 'var(--accent)'};">
                                        ${book.available ? book.availableCopies : 0}/${book.totalCopies}
                                    </span>
                                </div>
                                <div class="availability-bar">
                                    <div class="availability-fill" style="width:${book.availabilityPercent}%;"></div>
                                </div>
                            </div>

                            <div class="book-tile-footer">
                                <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${book.id})">Preview</button>
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn ${book.available ? 'btn-primary' : 'btn-gold-outline'} btn-sm" style="flex:1;">
                                    ${book.available ? 'Borrow Now' : 'Join Waitlist'}
                                </a>
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
