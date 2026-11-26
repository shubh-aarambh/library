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
        <div style="font-size:0.83rem; color:var(--ink-3); margin-bottom:1.5rem; display:flex; justify-content:space-between; align-items:center;">
            <div>
                <a href="${pageContext.request.contextPath}/books" class="header-link">Books</a> /
                <a href="${pageContext.request.contextPath}/books?genre=${book.genre}" class="header-link">${book.genre}</a> /
                <span>${book.title}</span>
            </div>
            <c:if test="${not empty currentUser && currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/books/edit/${book.id}" class="btn btn-secondary btn-sm">Edit in Staff Admin</a>
            </c:if>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty infoMessage}">
            <div class="alert alert-info">${infoMessage}</div>
        </c:if>

        <div class="detail-grid">
            <!-- Left Column: Cover + Primary Actions -->
            <div>
                <div class="book-cover-frame" style="background:${book.coverColor}; margin-bottom:1.15rem;">
                    <c:if test="${not empty book.resolvedCoverUrl}">
                        <img class="book-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" onerror="this.style.display='none'">
                    </c:if>
                    <div class="book-cover-fallback">
                        <span class="book-cover-fallback-genre">${book.genre}</span>
                        <div>
                            <div class="book-cover-fallback-title" style="font-size:1.45rem;">${book.title}</div>
                            <div class="book-cover-fallback-author">${book.author.name}</div>
                        </div>
                    </div>
                </div>

                <div style="display:flex; flex-direction:column; gap:8px;">
                    <c:choose>
                        <c:when test="${hasActiveLoan}">
                            <a href="${pageContext.request.contextPath}/my-library" class="btn btn-primary btn-block">Checked out · Open My Shelf</a>
                        </c:when>
                        <c:when test="${book.available}">
                            <form action="${pageContext.request.contextPath}/books/${book.id}/borrow" method="post" style="display:flex; flex-direction:column; gap:8px;">
                                <select name="days" class="select" aria-label="Loan period">
                                    <option value="7">Loan for 7 days</option>
                                    <option value="14" selected>Loan for 14 days</option>
                                    <option value="21">Loan for 21 days</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-block">Borrow copy</button>
                            </form>
                        </c:when>
                        <c:when test="${hasActiveHold}">
                            <a href="${pageContext.request.contextPath}/my-library" class="btn btn-secondary btn-block">On waitlist · View My Shelf</a>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/books/${book.id}/hold" method="post">
                                <button type="submit" class="btn btn-primary btn-block">Join waitlist (Position #${waitlistCount + 1})</button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <button type="button" class="btn btn-secondary btn-block" onclick="openReaderPreview(${book.id})">Read study guide</button>

                    <form action="${pageContext.request.contextPath}/books/${book.id}/reading-list" method="post">
                        <button type="submit" class="btn btn-ghost btn-block" style="border:1px solid var(--border);">
                            ${inReadingList ? 'Saved in Reading List ✓' : '+ Save for later'}
                        </button>
                    </form>
                </div>
            </div>

            <!-- Right Column: Editorial Book Info -->
            <div>
                <div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:0.75rem;">
                    <span class="tag ${book.available ? 'tag-green' : 'tag-amber'}">
                        <c:choose>
                            <c:when test="${book.available}">${book.availableCopies} of ${book.totalCopies} copies available</c:when>
                            <c:otherwise>All copies out · ${waitlistCount} waiting</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="tag">${book.formatLabel}</span>
                    <span class="tag">${book.genre}</span>
                </div>

                <h1 class="serif" style="font-size:2.4rem; line-height:1.12; margin-bottom:0.35rem;">${book.title}</h1>
                <p style="font-size:1.02rem; color:var(--ink-2); margin-bottom:1.1rem;">
                    by <a href="${pageContext.request.contextPath}/authors/${book.author.id}" style="color:var(--ink); font-weight:600; text-decoration:underline; text-underline-offset:3px;">${book.author.name}</a>
                    · <span class="mono">${book.rating} ★</span> (${reviews.size()} reviews)
                </p>

                <p style="font-size:0.98rem; color:var(--ink); line-height:1.72; max-width:680px;">
                    ${book.description}
                </p>

                <c:if test="${not empty book.librarianNote}">
                    <blockquote class="note-quote">
                        <strong style="color:var(--ink); display:block; margin-bottom:2px; font-size:0.82rem; text-transform:uppercase; letter-spacing:0.05em;">Librarian’s Note</strong>
                        ${book.librarianNote}
                    </blockquote>
                </c:if>

                <div class="meta-table" style="max-width:520px;">
                    <div class="meta-row"><span>Published</span><strong>${book.publishedYear}</strong></div>
                    <div class="meta-row"><span>Length</span><strong>${book.pages} pages (${book.formattedReadingTime})</strong></div>
                    <div class="meta-row"><span>Language</span><strong>${book.language}</strong></div>
                    <div class="meta-row"><span>Shelf Location</span><strong class="mono">${book.shelfLocation}</strong></div>
                    <div class="meta-row"><span>ISBN</span><strong class="mono">${book.isbn}</strong></div>
                </div>
            </div>
        </div>

        <!-- Reader Reviews -->
        <div class="split-2">
            <div>
                <div class="section-head">
                    <h2>Reader Reviews (${reviews.size()})</h2>
                </div>
                <c:choose>
                    <c:when test="${empty reviews}">
                        <p style="color:var(--ink-2); font-size:0.9rem;">No reviews yet. Be the first reader to share a note.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rev" items="${reviews}">
                            <div style="padding:1rem 0; border-bottom:1px solid var(--border);">
                                <div style="display:flex; justify-content:space-between; margin-bottom:4px;">
                                    <strong>${rev.member.fullName}</strong>
                                    <span class="mono" style="font-size:0.84rem;">${rev.rating} / 5 ★</span>
                                </div>
                                <div style="font-size:0.76rem; color:var(--ink-3); margin-bottom:6px;">${rev.formattedDate}</div>
                                <p style="font-size:0.9rem; color:var(--ink-2);">${rev.comment}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="panel">
                <h3 class="serif" style="font-size:1.35rem; margin-bottom:0.85rem;">Write a review</h3>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <form action="${pageContext.request.contextPath}/books/${book.id}/reviews" method="post">
                            <div class="form-group">
                                <label for="rating">Rating</label>
                                <select name="rating" id="rating" class="form-control">
                                    <option value="5">5 — Essential read</option>
                                    <option value="4">4 — Strongly recommend</option>
                                    <option value="3">3 — Good</option>
                                    <option value="2">2 — Fair</option>
                                    <option value="1">1 — Not for me</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="comment">Your note</label>
                                <textarea name="comment" id="comment" class="form-control" rows="3" required placeholder="Share your thoughts on this edition..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Post review</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p style="font-size:0.88rem; color:var(--ink-2); margin-bottom:1rem;">Sign in to borrow books, join waitlists, and post reviews.</p>
                        <div style="display:flex; flex-direction:column; gap:8px;">
                            <form action="${pageContext.request.contextPath}/demo-login" method="post">
                                <input type="hidden" name="next" value="/books/${book.id}">
                                <button type="submit" class="btn btn-primary btn-block">Sign in as Demo Reader</button>
                            </form>
                            <a href="${pageContext.request.contextPath}/login?next=/books/${book.id}" class="btn btn-secondary btn-block">Sign in / Register</a>
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
