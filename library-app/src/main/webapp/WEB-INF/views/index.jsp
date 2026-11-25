<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Athenaeum — Digital Library &amp; Circulation Platform</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <section class="hero-section">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>

        <div class="hero-grid">
            <div>
                <div class="hero-badge">
                    <span class="pulse-dot"></span>
                    <span>LIVE CIRCULATION · SPRING BOOT &amp; JPA</span>
                </div>
                <h1 class="hero-title">
                    Curated literature,<br>
                    <span class="accent">intelligent circulation.</span>
                </h1>
                <p class="hero-desc">
                    Discover timeless volumes across genres, borrow copies with live inventory tracking, curate your personal reading list, or switch into the dedicated Admin Control Plane.
                </p>

                <form action="${pageContext.request.contextPath}/books" method="get" class="hero-search">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="color:var(--text-muted); flex-shrink:0;">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <input type="text" name="q" data-quick-search placeholder="Search by title, author, genre, or ISBN...">
                    <span class="kbd-hint">/</span>
                    <button type="submit" class="btn btn-primary btn-sm">Explore</button>
                </form>

                <div class="hero-cta-row">
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">Browse Catalog</a>
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <a href="${pageContext.request.contextPath}/my-library" class="btn btn-secondary">Open My Library</a>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/demo-login" method="post" style="display:inline;">
                                <button type="submit" class="btn btn-gold-outline">1-Click Demo Reader</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Admin Console ↗</a>
                </div>
            </div>

            <div class="hero-bento">
                <div class="bento-stat">
                    <div class="bento-label">Catalog Volumes</div>
                    <div class="bento-value">${stats.totalBooks}</div>
                    <div class="bento-sub">${stats.availableCopies} of ${stats.totalCopies} copies on shelf</div>
                </div>
                <div class="bento-stat">
                    <div class="bento-label">Literary Authors</div>
                    <div class="bento-value">${stats.totalAuthors}</div>
                    <div class="bento-sub">Across ${stats.totalGenres} curated genres</div>
                </div>
                <div class="bento-stat">
                    <div class="bento-label">Active Circulation</div>
                    <div class="bento-value">${stats.openLoans}</div>
                    <div class="bento-sub">${stats.utilizationPct}% shelf utilization</div>
                </div>
                <div class="bento-stat">
                    <div class="bento-label">Reader Rating</div>
                    <div class="bento-value">${stats.avgRating} ★</div>
                    <div class="bento-sub">${stats.totalMembers} registered members</div>
                </div>
                <div class="bento-stat wide">
                    <div>
                        <div class="bento-label" style="color:var(--gold);">Dual-Portal Architecture</div>
                        <div style="font-weight:700; font-size:1.02rem;">Reader Experience + Role-Based Admin Site</div>
                        <div class="bento-sub">Live loan desk, overdue fine tracking, audit logs &amp; Chart.js analytics</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-primary btn-sm">Launch Admin</a>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <!-- Genre Quick Strip -->
        <div class="genre-pills">
            <a href="${pageContext.request.contextPath}/books" class="genre-pill active">All Genres (${stats.totalBooks})</a>
            <c:forEach var="g" items="${genreBreakdown}">
                <a href="${pageContext.request.contextPath}/books?genre=${g[0]}" class="genre-pill">${g[0]} (${g[1]})</a>
            </c:forEach>
        </div>

        <!-- Staff Picks / Featured Shelf -->
        <div class="section-header">
            <div>
                <div class="section-kicker">Curated Showcase</div>
                <h2 class="section-title">Featured Staff Picks</h2>
                <p class="section-subtitle">Handpicked masterpieces ready for immediate borrowing</p>
            </div>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">View Full Catalog →</a>
        </div>

        <div class="books-grid" style="margin-bottom:3.5rem;">
            <c:forEach var="book" items="${featuredBooks}">
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
                        <div class="book-meta-row">
                            <span class="mono">Shelf ${book.shelfLocation}</span>
                            <c:choose>
                                <c:when test="${book.available}">
                                    <span class="badge badge-emerald">${book.availableCopies}/${book.totalCopies} Available</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Checked Out</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="book-actions">
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary btn-sm" style="flex:1;">Inspect &amp; Borrow</a>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>

        <!-- Spotlight Authors -->
        <div class="section-header">
            <div>
                <div class="section-kicker">Literary Voices</div>
                <h2 class="section-title">Featured Authors</h2>
                <p class="section-subtitle">Explore biographies, honors, and linked bibliographies</p>
            </div>
            <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">All Authors →</a>
        </div>

        <div class="authors-grid" style="margin-bottom:3.5rem;">
            <c:forEach var="author" items="${spotlightAuthors}">
                <a href="${pageContext.request.contextPath}/authors/${author.id}" class="author-card">
                    <div class="author-header">
                        <div class="author-monogram" style="background:${author.avatarColor};">${author.initials}</div>
                        <div>
                            <h3 style="font-size:1.05rem; font-weight:700;">${author.name}</h3>
                            <div style="font-size:0.82rem; color:var(--text-muted);">${author.nationality} · Born ${author.birthYear}</div>
                        </div>
                    </div>
                    <p style="font-size:0.85rem; color:var(--text-soft); flex:1;">${author.biography}</p>
                    <div style="display:flex; align-items:center; justify-content:space-between; gap:8px;">
                        <c:if test="${not empty author.notableAward}">
                            <span class="badge" style="font-size:0.7rem;">${author.notableAward}</span>
                        </c:if>
                        <span class="mono" style="font-size:0.78rem; color:var(--gold); margin-left:auto;">${author.books.size()} Volume(s)</span>
                    </div>
                </a>
            </c:forEach>
        </div>

        <!-- Engineering & Platform Modules -->
        <div class="section-header">
            <div>
                <div class="section-kicker">Platform Modules</div>
                <h2 class="section-title">Built for Readers &amp; Librarians</h2>
            </div>
        </div>
        <div class="authors-grid">
            <a href="${pageContext.request.contextPath}/books/joined" class="author-card">
                <span class="badge badge-sky" style="width:fit-content;">JPQL INNER JOIN</span>
                <h3 class="serif" style="font-size:1.3rem;">Relational Join Explorer</h3>
                <p style="font-size:0.86rem; color:var(--text-soft);">Inspect live Hibernate JPQL inner-join projections linking Books and Authors with instant filtering and CSV export.</p>
            </a>
            <a href="${pageContext.request.contextPath}/my-library" class="author-card">
                <span class="badge badge-emerald" style="width:fit-content;">MEMBER SELF-SERVICE</span>
                <h3 class="serif" style="font-size:1.3rem;">Personal Reading Desk</h3>
                <p style="font-size:0.86rem; color:var(--text-soft);">Borrow available titles, renew due dates (+7 days), return books, curate bookmarks, and post verified reviews.</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin" class="author-card">
                <span class="badge" style="width:fit-content;">RBAC ADMIN SITE</span>
                <h3 class="serif" style="font-size:1.3rem;">Admin Command Center</h3>
                <p style="font-size:0.86rem; color:var(--text-soft);">Dedicated sidebar console for inventory management, manual loan issuance, fine settlement, member tiers &amp; audit trails.</p>
            </a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
