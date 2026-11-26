<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${book.title} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div style="margin-bottom:1.4rem; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:10px;">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">← Back to Catalog</a>
            <c:if test="${not empty currentUser && currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/books/edit/${book.id}" class="btn btn-dark btn-sm">Edit in Librarian Console</a>
            </c:if>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
        </c:if>
        <c:if test="${not empty infoMessage}">
            <div class="alert alert-info" data-autoclose><span>${infoMessage}</span></div>
        </c:if>

        <div class="card" style="padding:2rem; margin-bottom:2rem;">
            <div class="detail-hero">
                <div>
                    <div class="real-cover" style="background:${book.coverColor};">
                        <c:if test="${not empty book.resolvedCoverUrl}">
                            <img class="real-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" onerror="this.style.display='none'">
                        </c:if>
                        <div class="cover-fallback">
                            <span class="badge" style="width:fit-content; background:rgba(0,0,0,0.4); color:#fde68a; border-color:rgba(255,255,255,0.2);">${book.genre}</span>
                            <div>
                                <div class="cover-fallback-title" style="font-size:1.75rem;">${book.title}</div>
                                <div class="cover-fallback-author" style="font-size:0.95rem; margin-top:6px;">${book.author.name}</div>
                            </div>
                        </div>
                    </div>

                    <button type="button" class="btn btn-dark btn-block" style="margin-top:1.1rem;" onclick="openReaderPreview(${book.id})">
                        Open E-Reader Preview &amp; Guide
                    </button>
                </div>

                <div>
                    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:0.85rem;">
                        <span class="badge badge-neutral">${book.genre}</span>
                        <span class="badge badge-sky">${book.formatLabel}</span>
                        <c:if test="${book.featured}">
                            <span class="badge badge-violet">★ Staff Pick</span>
                        </c:if>
                        <c:choose>
                            <c:when test="${book.available}">
                                <span class="badge badge-emerald">${book.availableCopies} of ${book.totalCopies} Copies On Shelf</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">All Copies Checked Out · ${waitlistCount} in Waitlist</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h1 class="serif" style="font-size:2.9rem; line-height:1.08; margin-bottom:0.4rem;">${book.title}</h1>
                    <p style="font-size:1.05rem; color:var(--text-soft); margin-bottom:1.15rem;">
                        by <a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="color:var(--accent); font-weight:700;">${book.author.name}</a>
                        (${book.author.nationality}) · <strong style="color:var(--accent);">★ ${book.rating}</strong>
                    </p>

                    <p style="font-size:0.99rem; color:var(--text); line-height:1.75;">
                        ${book.description}
                    </p>

                    <c:if test="${not empty book.librarianNote}">
                        <div class="librarian-callout">
                            <strong style="color:var(--text); display:block; margin-bottom:3px;">Why Athenaeum Librarians Recommend This Edition</strong>
                            ${book.librarianNote}
                        </div>
                    </c:if>

                    <div class="spec-grid">
                        <div class="spec-box"><span>Published</span><strong>${book.publishedYear}</strong></div>
                        <div class="spec-box"><span>Reading Time</span><strong>${book.formattedReadingTime}</strong></div>
                        <div class="spec-box"><span>Length</span><strong>${book.pages} pages</strong></div>
                        <div class="spec-box"><span>Shelf Location</span><strong class="mono">${book.shelfLocation}</strong></div>
                        <div class="spec-box"><span>ISBN</span><strong class="mono" style="font-size:0.8rem;">${book.isbn}</strong></div>
                    </div>

                    <!-- Primary Action Row: Borrow / Waitlist Hold / Bookmark -->
                    <div style="display:flex; flex-wrap:wrap; gap:10px; align-items:center; margin-top:1.4rem;">
                        <c:choose>
                            <c:when test="${hasActiveLoan}">
                                <a href="${pageContext.request.contextPath}/my-library" class="btn btn-emerald btn-lg">Checked Out · Open Pickup Pass &amp; Progress</a>
                            </c:when>
                            <c:when test="${book.available}">
                                <form action="${pageContext.request.contextPath}/books/${book.id}/borrow" method="post" style="display:flex; gap:8px; align-items:center;">
                                    <select name="days" class="filter-select" aria-label="Loan window">
                                        <option value="7">7 Days</option>
                                        <option value="14" selected>14 Days (Standard)</option>
                                        <option value="21">21 Days</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-lg">Borrow &amp; Get Pickup Pass</button>
                                </form>
                            </c:when>
                            <c:when test="${hasActiveHold}">
                                <a href="${pageContext.request.contextPath}/my-library" class="btn btn-gold-outline btn-lg">✓ On Waitlist · Check Hold Status</a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/books/${book.id}/hold" method="post">
                                    <button type="submit" class="btn btn-primary btn-lg">Join Waitlist Queue (Position #${waitlistCount + 1})</button>
                                </form>
                            </c:otherwise>
                        </c:choose>

                        <form action="${pageContext.request.contextPath}/books/${book.id}/reading-list" method="post">
                            <button type="submit" class="btn ${inReadingList ? 'btn-gold-outline' : 'btn-secondary'} btn-lg">
                                ${inReadingList ? '✓ Saved in Reading List' : '+ Save for Later'}
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews & Community Notes -->
        <div class="dashboard-split">
            <div class="card">
                <div class="section-header" style="margin-bottom:1.1rem;">
                    <div>
                        <div class="section-kicker">Reader Community</div>
                        <h2 class="serif" style="font-size:1.75rem;">Reviews (${reviews.size()})</h2>
                    </div>
                    <span class="badge">★ ${book.rating} / 5.0</span>
                </div>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="empty-state" style="padding:2rem 1rem;">
                            <p>No community reviews yet — share your perspective after reading!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rev" items="${reviews}">
                            <div class="timeline-item">
                                <div class="user-avatar" style="flex-shrink:0;">${rev.member.initials}</div>
                                <div style="flex:1;">
                                    <div style="display:flex; justify-content:space-between; align-items:center; gap:8px;">
                                        <strong>${rev.member.fullName}</strong>
                                        <span style="color:var(--accent); font-weight:700;">★ ${rev.rating}/5</span>
                                    </div>
                                    <div style="font-size:0.74rem; color:var(--text-muted); margin-bottom:4px;">${rev.formattedDate}</div>
                                    <p style="font-size:0.9rem; color:var(--text-soft);">${rev.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card">
                <div class="section-kicker">Add Your Voice</div>
                <h2 class="serif" style="font-size:1.7rem; margin-bottom:0.9rem;">Write a Review</h2>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <form action="${pageContext.request.contextPath}/books/${book.id}/reviews" method="post">
                            <div class="form-group">
                                <label for="rating">Rating</label>
                                <select name="rating" id="rating" class="form-control">
                                    <option value="5">★★★★★ — 5 / 5 Essential Read</option>
                                    <option value="4">★★★★☆ — 4 / 5 Strongly Recommended</option>
                                    <option value="3">★★★☆☆ — 3 / 5 Enjoyable</option>
                                    <option value="2">★★☆☆☆ — 2 / 5 Mixed</option>
                                    <option value="1">★☆☆☆☆ — 1 / 5 Not For Me</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="comment">Your Thoughts</label>
                                <textarea name="comment" id="comment" class="form-control" rows="4" required
                                          placeholder="Share what resonated with you about this book..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Publish Review</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p style="color:var(--text-soft); font-size:0.9rem; margin-bottom:1.15rem;">
                            Sign in with a reader account (or use our 1-Click Demo Reader) to borrow titles, join waitlists, and post reviews.
                        </p>
                        <div style="display:flex; flex-direction:column; gap:10px;">
                            <form action="${pageContext.request.contextPath}/demo-login" method="post">
                                <input type="hidden" name="next" value="/books/${book.id}">
                                <button type="submit" class="btn btn-primary btn-block">1-Click Demo Reader Sign In</button>
                            </form>
                            <a href="${pageContext.request.contextPath}/login?next=/books/${book.id}" class="btn btn-secondary btn-block">Sign In / Get Library Card</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
