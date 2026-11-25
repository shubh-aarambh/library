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
        <div style="margin-bottom:1.5rem; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:10px;">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">← Back to Catalog</a>
            <div style="display:flex; gap:8px;">
                <a href="${pageContext.request.contextPath}/books/edit/${book.id}" class="btn btn-secondary btn-sm">Edit Volume</a>
                <c:if test="${not empty currentUser && currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/admin/books/edit/${book.id}" class="btn btn-gold-outline btn-sm">Open in Admin</a>
                </c:if>
            </div>
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
                <div class="book-cover detail-cover-large" style="background:${book.coverColor};">
                    <div class="book-cover-top">
                        <span class="cover-genre">${book.genre}</span>
                        <span class="cover-rating">★ ${book.rating}</span>
                    </div>
                    <div>
                        <div class="book-cover-title">${book.title}</div>
                        <div class="book-cover-author" style="font-size:0.95rem; margin-top:8px;">${book.author.name}</div>
                    </div>
                </div>

                <div>
                    <div style="display:flex; flex-wrap:wrap; gap:8px; margin-bottom:0.85rem;">
                        <span class="badge">${book.genre}</span>
                        <c:if test="${book.featured}">
                            <span class="badge badge-violet">★ Staff Pick</span>
                        </c:if>
                        <c:choose>
                            <c:when test="${book.available}">
                                <span class="badge badge-emerald">${book.availableCopies} of ${book.totalCopies} Copies Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">All Copies Checked Out</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h1 class="serif" style="font-size:2.35rem; line-height:1.15; margin-bottom:0.4rem;">${book.title}</h1>
                    <p style="font-size:1.05rem; color:var(--text-soft); margin-bottom:1.2rem;">
                        by <a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="color:var(--gold); font-weight:700;">${book.author.name}</a>
                        (${book.author.nationality})
                    </p>

                    <p style="font-size:0.98rem; color:var(--text); line-height:1.75; margin-bottom:1.25rem;">
                        ${book.description}
                    </p>

                    <div class="spec-grid">
                        <div class="spec-box"><span>Published</span><strong>${book.publishedYear}</strong></div>
                        <div class="spec-box"><span>Pages</span><strong>${book.pages} pp</strong></div>
                        <div class="spec-box"><span>Language</span><strong>${book.language}</strong></div>
                        <div class="spec-box"><span>Shelf</span><strong class="mono">${book.shelfLocation}</strong></div>
                        <div class="spec-box"><span>ISBN</span><strong class="mono" style="font-size:0.82rem;">${book.isbn}</strong></div>
                    </div>

                    <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center; margin-top:1.5rem;">
                        <c:choose>
                            <c:when test="${hasActiveLoan}">
                                <a href="${pageContext.request.contextPath}/my-library" class="btn btn-emerald btn-lg">Currently Borrowed · Manage in My Library</a>
                            </c:when>
                            <c:when test="${book.available}">
                                <form action="${pageContext.request.contextPath}/books/${book.id}/borrow" method="post" style="display:flex; gap:8px; align-items:center;">
                                    <select name="days" class="filter-select" aria-label="Loan duration">
                                        <option value="7">7 Days</option>
                                        <option value="14" selected>14 Days (Standard)</option>
                                        <option value="21">21 Days</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-lg">Borrow Volume</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-secondary btn-lg" disabled style="opacity:0.55; cursor:not-allowed;">Currently Unavailable</button>
                            </c:otherwise>
                        </c:choose>

                        <form action="${pageContext.request.contextPath}/books/${book.id}/reading-list" method="post">
                            <button type="submit" class="btn ${inReadingList ? 'btn-gold-outline' : 'btn-secondary'} btn-lg">
                                ${inReadingList ? '✓ Saved in Reading List' : '+ Save to Reading List'}
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews & Rating Section -->
        <div class="dashboard-split">
            <div class="card">
                <div class="section-header" style="margin-bottom:1.25rem;">
                    <div>
                        <div class="section-kicker">Community Feedback</div>
                        <h2 class="serif" style="font-size:1.5rem;">Reader Reviews (${reviews.size()})</h2>
                    </div>
                    <span class="badge">Avg ★ ${book.rating} / 5.0</span>
                </div>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="empty-state" style="padding:2rem 1rem;">
                            <p>No reader reviews yet. Be the first to share your thoughts!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rev" items="${reviews}">
                            <div class="timeline-item">
                                <div class="user-avatar" style="flex-shrink:0;">${rev.member.initials}</div>
                                <div style="flex:1;">
                                    <div style="display:flex; justify-content:space-between; align-items:center; gap:8px;">
                                        <strong>${rev.member.fullName}</strong>
                                        <span style="color:var(--gold); font-weight:700;">★ ${rev.rating}/5</span>
                                    </div>
                                    <div style="font-size:0.75rem; color:var(--text-muted); margin-bottom:5px;">${rev.formattedDate}</div>
                                    <p style="font-size:0.9rem; color:var(--text-soft);">${rev.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card">
                <div class="section-kicker">Share Your Perspective</div>
                <h2 class="serif" style="font-size:1.45rem; margin-bottom:1rem;">Write a Review</h2>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <form action="${pageContext.request.contextPath}/books/${book.id}/reviews" method="post">
                            <div class="form-group">
                                <label for="rating">Your Rating</label>
                                <select name="rating" id="rating" class="form-control">
                                    <option value="5">★★★★★ — 5 / 5 Masterpiece</option>
                                    <option value="4">★★★★☆ — 4 / 5 Highly Recommended</option>
                                    <option value="3">★★★☆☆ — 3 / 5 Enjoyable</option>
                                    <option value="2">★★☆☆☆ — 2 / 5 Mixed</option>
                                    <option value="1">★☆☆☆☆ — 1 / 5 Not For Me</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="comment">Your Review</label>
                                <textarea name="comment" id="comment" class="form-control" rows="4" required
                                          placeholder="What stood out about this book?"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Publish Review</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p style="color:var(--text-soft); font-size:0.9rem; margin-bottom:1.25rem;">
                            Sign in with a reader account (or use our 1-click demo reader) to borrow volumes and publish reviews.
                        </p>
                        <div style="display:flex; flex-direction:column; gap:10px;">
                            <form action="${pageContext.request.contextPath}/demo-login" method="post">
                                <input type="hidden" name="next" value="/books/${book.id}">
                                <button type="submit" class="btn btn-primary btn-block">1-Click Demo Reader Sign In</button>
                            </form>
                            <a href="${pageContext.request.contextPath}/login?next=/books/${book.id}" class="btn btn-secondary btn-block">Sign In / Create Card</a>
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

