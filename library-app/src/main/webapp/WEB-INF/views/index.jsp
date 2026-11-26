<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Athenaeum — Smart Campus &amp; Digital Library</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <!-- Editorial Magazine Hero -->
    <div class="hero-wrap">
        <section class="hero-section">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
            </c:if>

            <div class="hero-grid">
                <div>
                    <div class="hero-eyebrow">
                        <span class="dot"></span>
                        <span>${stats.availableCopies} copies on shelf right now · Print &amp; Digital Access</span>
                    </div>

                    <h1 class="hero-title">
                        Your modern library,<br>
                        <em>designed for readers.</em>
                    </h1>

                    <p class="hero-desc">
                        Browse print &amp; digital books with real-time shelf availability, open our built-in study guide e-reader, reserve copies with QR pickup passes, join waitlists automatically, and track your reading progress.
                    </p>

                    <form action="${pageContext.request.contextPath}/books" method="get" class="hero-search">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="color:var(--accent); flex-shrink:0;">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input type="text" name="q" placeholder="Search Dune, George Orwell, Sci-Fi, or press ⌘K...">
                        <button type="submit" class="btn btn-primary btn-sm">Search Catalog</button>
                    </form>

                    <!-- Clear Dual-Portal Interactive Demo Actions -->
                    <div class="portal-switcher">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-dark">Browse Full Catalog</a>
                        <c:choose>
                            <c:when test="${not empty currentUser}">
                                <a href="${pageContext.request.contextPath}/my-library" class="btn btn-gold-outline">Open My Library Card</a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/demo-login" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-gold-outline">Try Demo Reader</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Librarian Admin Site ↗</a>
                    </div>

                    <div class="hero-trust-strip">
                        <div class="trust-metric">
                            <strong>${stats.totalBooks} Titles</strong>
                            <span>${stats.totalCopies} total shelf copies</span>
                        </div>
                        <div class="trust-metric">
                            <strong>${stats.totalAuthors} Authors</strong>
                            <span>Across ${stats.totalGenres} curated genres</span>
                        </div>
                        <div class="trust-metric">
                            <strong>${stats.openLoans} Active Loans</strong>
                            <span>${stats.openHolds} waitlist holds live</span>
                        </div>
                        <div class="trust-metric">
                            <strong>${stats.avgRating} ★</strong>
                            <span>Community reader rating</span>
                        </div>
                    </div>
                </div>

                <!-- 3D Fanned Real-Cover Book Showcase -->
                <div class="hero-showcase">
                    <div class="book-fan">
                        <c:forEach var="hb" items="${heroStack}">
                            <a href="${pageContext.request.contextPath}/books/${hb.id}" class="fan-book" style="background:${hb.coverColor};" title="${hb.title}">
                                <div class="real-cover" style="height:100%; aspect-ratio:auto; border-radius:0; box-shadow:none; background:${hb.coverColor};">
                                    <c:if test="${not empty hb.resolvedCoverUrl}">
                                        <img class="real-cover-img" src="${hb.resolvedCoverUrl}" alt="${hb.title}" onerror="this.style.display='none'">
                                    </c:if>
                                    <div class="cover-fallback">
                                        <span class="badge" style="width:fit-content; background:rgba(0,0,0,0.45); color:#fde68a; border-color:rgba(255,255,255,0.2);">${hb.genre}</span>
                                        <div>
                                            <div class="cover-fallback-title">${hb.title}</div>
                                            <div class="cover-fallback-author">${hb.author.name}</div>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                    <div class="hero-floating-pill">
                        <span style="width:8px; height:8px; border-radius:50%; background:var(--emerald);"></span>
                        <span>Click any cover to preview guide, borrow, or reserve</span>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <div class="container">
        <!-- Crystal-Clear 3-Step User Journey -->
        <div class="journey-strip">
            <div class="journey-card">
                <span class="journey-step">01 · Discover &amp; Preview</span>
                <h3>Browse real editions &amp; open the E-Reader</h3>
                <p>Use instant ⌘K search, filter by genre or reading time, and open our distraction-free Reader Guide before borrowing.</p>
            </div>
            <div class="journey-card">
                <span class="journey-step">02 · Borrow, Waitlist &amp; Track</span>
                <h3>QR pickup passes &amp; reading progress</h3>
                <p>Borrow shelf copies in one click, join automatic waitlists when copies are out, and track reading progress on your Digital Library Card.</p>
            </div>
            <div class="journey-card">
                <span class="journey-step">03 · Librarian Admin Console</span>
                <h3>Complete circulation &amp; inventory control</h3>
                <p>Switch to the RBAC-protected Librarian site to adjust stock, fulfill waitlist holds, settle overdue fines, and view Chart.js analytics.</p>
            </div>
        </div>

        <!-- Genre Quick Navigation -->
        <div class="genre-pills" style="margin-bottom:2.5rem;">
            <a href="${pageContext.request.contextPath}/books" class="genre-pill active">All Collections (${stats.totalBooks})</a>
            <c:forEach var="g" items="${genreBreakdown}">
                <a href="${pageContext.request.contextPath}/books?genre=${g[0]}" class="genre-pill">${g[0]} (${g[1]})</a>
            </c:forEach>
        </div>

        <!-- Staff Picks & Trending Showcase -->
        <section class="section-block">
            <div class="section-header">
                <div>
                    <div class="section-kicker">Librarian Curated</div>
                    <h2 class="section-title">Trending &amp; Staff Picks</h2>
                    <p class="section-subtitle">Most borrowed editions this month — preview the study guide or check out immediately</p>
                </div>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">Explore All ${stats.totalBooks} Books →</a>
            </div>

            <div class="books-grid">
                <c:forEach var="book" items="${featuredBooks}">
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
                        <div class="book-tile-author">by ${book.author.name}</div>

                        <div class="book-tile-footer">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${book.id})">Preview</button>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn ${book.available ? 'btn-primary' : 'btn-gold-outline'} btn-sm" style="flex:1;">
                                ${book.available ? 'Borrow' : 'Join Waitlist'}
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>

        <!-- Quick Weekend Reads (< 315 pages) -->
        <section class="section-block">
            <div class="section-header">
                <div>
                    <div class="section-kicker">Short &amp; Absorbing</div>
                    <h2 class="section-title">Finish in a Weekend</h2>
                    <p class="section-subtitle">Compact masterpieces under 315 pages for focused evening reading</p>
                </div>
                <a href="${pageContext.request.contextPath}/books?sort=pages_asc" class="btn btn-secondary btn-sm">Sort by Shortest →</a>
            </div>

            <div class="books-grid">
                <c:forEach var="book" items="${quickReads}">
                    <article class="book-tile">
                        <div class="book-tile-cover-wrap">
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="real-cover" style="background:${book.coverColor};">
                                <c:if test="${not empty book.resolvedCoverUrl}">
                                    <img class="real-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" loading="lazy" onerror="this.style.display='none'">
                                </c:if>
                                <span class="cover-ribbon ${book.available ? 'avail' : 'waitlist'}">${book.pages}p</span>
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
                            <span>${book.formattedReadingTime}</span>
                            <span style="color:var(--accent);">★ ${book.rating}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-tile-title">${book.title}</a>
                        <div class="book-tile-author">by ${book.author.name} · Shelf ${book.shelfLocation}</div>
                        <div class="book-tile-footer">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${book.id})">Preview</button>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-dark btn-sm" style="flex:1;">View Edition</a>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>

        <!-- Featured Authors -->
        <section class="section-block" style="margin-bottom:1.5rem;">
            <div class="section-header">
                <div>
                    <div class="section-kicker">Author Spotlight</div>
                    <h2 class="section-title">Voices in the Archive</h2>
                    <p class="section-subtitle">Explore biographies, honors, and linked collections by author</p>
                </div>
                <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">All ${stats.totalAuthors} Authors →</a>
            </div>

            <div class="authors-grid">
                <c:forEach var="author" items="${spotlightAuthors}">
                    <a href="${pageContext.request.contextPath}/authors/${author.id}" class="author-card">
                        <div class="author-header">
                            <div class="author-monogram" style="background:${author.avatarColor};">${author.initials}</div>
                            <div>
                                <h3 style="font-size:1.05rem; font-weight:700;">${author.name}</h3>
                                <div style="font-size:0.8rem; color:var(--text-muted);">${author.nationality} · b. ${author.birthYear}</div>
                            </div>
                        </div>
                        <p style="font-size:0.86rem; color:var(--text-soft); flex:1;">${author.biography}</p>
                        <div style="display:flex; align-items:center; justify-content:space-between; gap:8px;">
                            <c:if test="${not empty author.notableAward}">
                                <span class="badge badge-neutral" style="font-size:0.7rem;">${author.notableAward}</span>
                            </c:if>
                            <span class="mono" style="font-size:0.77rem; color:var(--accent); font-weight:700; margin-left:auto;">${author.books.size()} Title(s) →</span>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
