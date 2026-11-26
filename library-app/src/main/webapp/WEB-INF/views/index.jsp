<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Athenaeum — Public &amp; Digital Library</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <!-- Featured Staff Pick Spread (Clean Editorial Layout — Like Bookshop.org / NYPL) -->
    <c:if test="${not empty featuredBooks}">
        <c:set var="lead" value="${featuredBooks[0]}"/>
        <section class="featured-band">
            <div class="featured-inner">
                <a href="${pageContext.request.contextPath}/books/${lead.id}" class="book-cover-frame" style="margin-bottom:0; background:${lead.coverColor};">
                    <c:if test="${not empty lead.resolvedCoverUrl}">
                        <img class="book-cover-img" src="${lead.resolvedCoverUrl}" alt="${lead.title}" onerror="this.style.display='none'">
                    </c:if>
                    <div class="book-cover-fallback">
                        <span class="book-cover-fallback-genre">${lead.genre}</span>
                        <div>
                            <div class="book-cover-fallback-title">${lead.title}</div>
                            <div class="book-cover-fallback-author">${lead.author.name}</div>
                        </div>
                    </div>
                </a>

                <div>
                    <div class="featured-label">Librarian’s Pick</div>
                    <h1 class="featured-title">${lead.title}</h1>
                    <div class="featured-author">
                        by <a href="${pageContext.request.contextPath}/authors/${lead.author.id}" style="text-decoration:underline; text-underline-offset:3px;">${lead.author.name}</a>
                        · ${lead.genre} · ${lead.publishedYear}
                    </div>
                    <p class="featured-desc">${lead.description}</p>
                    <div class="featured-actions">
                        <a href="${pageContext.request.contextPath}/books/${lead.id}" class="btn btn-primary">
                            ${lead.available ? 'Borrow copy' : 'Join waitlist'}
                        </a>
                        <button type="button" class="btn btn-secondary" onclick="openReaderPreview(${lead.id})">Read study notes</button>
                        <span style="font-size:0.82rem; color:var(--ink-2); margin-left:4px;">
                            ${lead.availableCopies} of ${lead.totalCopies} copies on Shelf ${lead.shelfLocation}
                        </span>
                    </div>
                </div>

                <!-- Honest, Grounded Library Status & Role Access Box -->
                <aside class="featured-aside">
                    <div>
                        <div style="font-size:0.78rem; font-weight:600; color:var(--ink-3); text-transform:uppercase; letter-spacing:0.05em; margin-bottom:6px;">
                            Library Catalog Status
                        </div>
                        <div class="aside-stat-row"><span>Available copies</span><strong>${stats.availableCopies} / ${stats.totalCopies}</strong></div>
                        <div class="aside-stat-row"><span>Titles &amp; authors</span><strong>${stats.totalBooks} / ${stats.totalAuthors}</strong></div>
                        <div class="aside-stat-row"><span>Active loans</span><strong>${stats.openLoans}</strong></div>
                        <div class="aside-stat-row"><span>Waitlist holds</span><strong>${stats.openHolds}</strong></div>
                    </div>
                    <div style="display:flex; flex-direction:column; gap:7px;">
                        <c:choose>
                            <c:when test="${not empty currentUser}">
                                <a href="${pageContext.request.contextPath}/my-library" class="btn btn-dark btn-sm btn-block">Open My Shelf</a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/demo-login" method="post">
                                    <button type="submit" class="btn btn-dark btn-sm btn-block">Try Demo Member Account</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary btn-sm btn-block">Staff / Librarian Admin</a>
                    </div>
                </aside>
            </div>
        </section>
    </c:if>

    <div class="container" style="padding-top:0.5rem;">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" style="margin-top:1.25rem;">${successMessage}</div>
        </c:if>

        <!-- Clean Underlined Category Bar -->
        <nav class="category-bar" aria-label="Genres">
            <a href="${pageContext.request.contextPath}/books" class="active">All Books (${stats.totalBooks})</a>
            <c:forEach var="g" items="${genreBreakdown}">
                <a href="${pageContext.request.contextPath}/books?genre=${g[0]}">${g[0]} (${g[1]})</a>
            </c:forEach>
        </nav>

        <!-- Shelf 1: Popular & Staff Picks -->
        <section>
            <div class="section-head">
                <h2>Staff Picks &amp; Popular Editions</h2>
                <a href="${pageContext.request.contextPath}/books">Browse all ${stats.totalBooks} books →</a>
            </div>

            <div class="shelf-grid">
                <c:forEach var="book" items="${featuredBooks}">
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
                                ${book.available ? 'Available' : 'Waitlist'}
                            </span>
                            <span class="mono">${book.rating} ★</span>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>

        <!-- Shelf 2: Shorter Weekend Reads -->
        <section>
            <div class="section-head">
                <h2>Shorter Reads (Under 315 Pages)</h2>
                <a href="${pageContext.request.contextPath}/books?sort=pages_asc">Sort by length →</a>
            </div>

            <div class="shelf-grid">
                <c:forEach var="book" items="${quickReads}">
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
                            <span>${book.pages} pages · ${book.formattedReadingTime}</span>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>

        <!-- Shelf 3: Authors in Archive -->
        <section>
            <div class="section-head">
                <h2>Authors in the Collection</h2>
                <a href="${pageContext.request.contextPath}/authors">All ${stats.totalAuthors} authors →</a>
            </div>

            <div class="author-list-grid">
                <c:forEach var="author" items="${spotlightAuthors}">
                    <a href="${pageContext.request.contextPath}/authors/${author.id}" class="author-tile">
                        <div class="author-head">
                            <div class="author-circle" style="background:${author.avatarColor};">${author.initials}</div>
                            <div>
                                <div style="font-weight:600; font-size:0.96rem;">${author.name}</div>
                                <div style="font-size:0.8rem; color:var(--ink-3);">${author.nationality} · ${author.books.size()} title(s)</div>
                            </div>
                        </div>
                        <p style="font-size:0.85rem; color:var(--ink-2);">${author.biography}</p>
                    </a>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
