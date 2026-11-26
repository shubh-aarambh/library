<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Shelf — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="page-top">
            <div>
                <h1 class="page-title">My Shelf</h1>
                <p class="page-sub">Signed in as ${member.fullName} (${member.email})</p>
            </div>
            <div style="display:flex; gap:8px;">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Browse books</a>
                <c:if test="${member.admin}">
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary btn-sm">Staff Admin ↗</a>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <!-- Library Card + Reading Goal -->
        <div class="member-banner">
            <div class="card-pass">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:1rem;">
                    <div>
                        <div style="font-size:0.7rem; text-transform:uppercase; letter-spacing:0.12em; opacity:0.7;">Athenaeum Library Card</div>
                        <div class="serif" style="font-size:1.75rem; margin-top:4px; line-height:1.15;">${member.fullName}</div>
                        <div class="mono" style="font-size:0.86rem; opacity:0.85; margin-top:4px;">${member.libraryCardNumber}</div>
                    </div>
                    <div class="qr-square" title="Kiosk Pass ${member.libraryCardNumber}">
                        <svg viewBox="0 0 29 29" width="52" height="52" shape-rendering="crispEdges">
                            <rect width="29" height="29" fill="#fff"/>
                            <path fill="#111315" d="M2 2h7v7H2zM3 3v5h5V3zM4 4h3v3H4zM20 2h7v7h-7zM21 3v5h5V3zM22 4h3v3h-3zM2 20h7v7H2zM3 21v5h5v-5zM4 22h3v3H4zM11 2h2v2h-2zM15 2h2v3h-2zM11 6h4v2h-4zM17 6h2v4h-2zM2 11h3v2H2zM7 11h4v2H7zM13 11h3v4h-3zM19 11h2v2h-2zM23 11h4v2h-4zM4 15h3v3H4zM9 15h2v3H9zM17 15h4v2h-4zM23 15h2v4h-2zM11 19h2v4h-2zM15 19h3v2h-3zM20 19h3v3h-3zM25 21h2v4h-2zM14 23h4v4h-4zM20 24h3v3h-3z"/>
                        </svg>
                    </div>
                </div>
                <div style="display:flex; gap:1.75rem; flex-wrap:wrap; font-size:0.82rem; opacity:0.85; padding-top:0.85rem; border-top:1px solid rgba(255,255,255,0.14);">
                    <span>Tier: <strong>${member.membershipTier}</strong></span>
                    <span>Loans: <strong>${activeLoans.size()} / ${member.borrowLimit}</strong></span>
                    <span>Joined: <strong>${member.formattedJoinedDate}</strong></span>
                </div>
            </div>

            <div class="panel" style="display:flex; flex-direction:column; justify-content:space-between; gap:1rem;">
                <div>
                    <div style="font-size:0.74rem; font-weight:600; text-transform:uppercase; letter-spacing:0.06em; color:var(--ink-3);">2026 Reading Goal</div>
                    <div style="display:flex; justify-content:space-between; align-items:baseline; margin-top:4px;">
                        <span class="serif" style="font-size:1.55rem;">${pastLoans.size()} of ${member.annualReadingGoal} books</span>
                        <span class="mono" style="font-size:0.85rem; color:var(--accent); font-weight:600;">${goalPercent}%</span>
                    </div>
                    <div class="progress-track" style="margin:0.75rem 0;">
                        <div class="progress-bar" style="width:${goalPercent}%;"></div>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/my-library/goal" method="post" style="display:flex; align-items:center; gap:8px;">
                    <label for="goal" style="font-size:0.8rem; color:var(--ink-2);">Yearly target:</label>
                    <input type="number" id="goal" name="goal" value="${member.annualReadingGoal}" min="1" max="200" class="input" style="width:74px; padding:6px 8px;">
                    <button type="submit" class="btn btn-secondary btn-sm">Save</button>
                </form>
            </div>
        </div>

        <!-- Currently Borrowed -->
        <section style="margin-bottom:2.5rem;">
            <div class="section-head">
                <h2>Currently Borrowed (${activeLoans.size()})</h2>
            </div>
            <c:choose>
                <c:when test="${empty activeLoans}">
                    <p style="color:var(--ink-2); font-size:0.9rem;">No books currently checked out.</p>
                </c:when>
                <c:otherwise>
                    <div class="panel" style="padding:0.25rem 1.25rem;">
                        <c:forEach var="loan" items="${activeLoans}">
                            <div class="loan-row-card">
                                <a href="${pageContext.request.contextPath}/books/${loan.book.id}" class="book-cover-frame" style="height:88px; width:58px; aspect-ratio:auto; margin:0; background:${loan.book.coverColor};">
                                    <c:if test="${not empty loan.book.resolvedCoverUrl}">
                                        <img class="book-cover-img" src="${loan.book.resolvedCoverUrl}" alt="${loan.book.title}" onerror="this.style.display='none'">
                                    </c:if>
                                </a>
                                <div>
                                    <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px; margin-bottom:2px;">
                                        <a href="${pageContext.request.contextPath}/books/${loan.book.id}" class="serif" style="font-size:1.25rem;">${loan.book.title}</a>
                                        <span class="tag mono">${loan.pickupCode}</span>
                                        <c:choose>
                                            <c:when test="${loan.status == 'OVERDUE'}"><span class="tag tag-red">Overdue · $${loan.computedFine}</span></c:when>
                                            <c:otherwise><span class="tag tag-green">Due ${loan.formattedDueDate}</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="font-size:0.82rem; color:var(--ink-3); margin-bottom:0.65rem;">
                                        ${loan.book.author.name} · Shelf ${loan.book.shelfLocation}
                                    </div>
                                    <form action="${pageContext.request.contextPath}/my-library/progress/${loan.id}" method="post" style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                        <span style="font-size:0.78rem; color:var(--ink-2);">Progress:</span>
                                        <input type="range" name="progress" min="0" max="100" step="5" value="${loan.readingProgress}"
                                               oninput="this.nextElementSibling.textContent = this.value + '%'"
                                               style="accent-color:var(--accent); width:150px;">
                                        <span class="mono" style="font-size:0.8rem; min-width:34px;">${loan.readingProgress}%</span>
                                        <button type="submit" class="btn btn-secondary btn-sm">Update</button>
                                    </form>
                                </div>
                                <div style="display:flex; flex-direction:column; gap:6px;">
                                    <button type="button" class="btn btn-ghost btn-sm" onclick="openReaderPreview(${loan.book.id})">Notes</button>
                                    <form action="${pageContext.request.contextPath}/my-library/renew/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-secondary btn-sm btn-block">Renew +7d</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/my-library/return/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-primary btn-sm btn-block">Return</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Waitlist Holds -->
        <section style="margin-bottom:2.5rem;">
            <div class="section-head">
                <h2>Waitlist Holds (${activeHolds.size()})</h2>
            </div>
            <c:choose>
                <c:when test="${empty activeHolds}">
                    <p style="color:var(--ink-2); font-size:0.9rem;">No active waitlist holds.</p>
                </c:when>
                <c:otherwise>
                    <div class="panel" style="padding:0;">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr><th>Book</th><th>Requested</th><th>Status</th><th></th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${activeHolds}">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/books/${h.book.id}" style="font-weight:600;">${h.book.title}</a></td>
                                            <td>${h.formattedRequestedDate}</td>
                                            <td>
                                                <span class="tag ${h.status == 'READY' ? 'tag-green' : 'tag-amber'}">
                                                    ${h.status == 'READY' ? 'Ready for pickup' : 'Waiting in queue'}
                                                </span>
                                            </td>
                                            <td style="text-align:right;">
                                                <form action="${pageContext.request.contextPath}/my-library/holds/cancel/${h.id}" method="post" style="display:inline;">
                                                    <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Saved Reading List -->
        <section style="margin-bottom:2.5rem;">
            <div class="section-head">
                <h2>Saved for Later (${readingList.size()})</h2>
            </div>
            <c:choose>
                <c:when test="${empty readingList}">
                    <p style="color:var(--ink-2); font-size:0.9rem;">Bookmark any book to save it here.</p>
                </c:when>
                <c:otherwise>
                    <div class="shelf-grid">
                        <c:forEach var="item" items="${readingList}">
                            <article class="book-item">
                                <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="book-cover-frame" style="background:${item.book.coverColor};">
                                    <c:if test="${not empty item.book.resolvedCoverUrl}">
                                        <img class="book-cover-img" src="${item.book.resolvedCoverUrl}" alt="${item.book.title}" loading="lazy" onerror="this.style.display='none'">
                                    </c:if>
                                    <div class="book-cover-fallback">
                                        <span class="book-cover-fallback-genre">${item.book.genre}</span>
                                        <div class="book-cover-fallback-title">${item.book.title}</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="book-item-title">${item.book.title}</a>
                                <div class="book-item-author">${item.book.author.name}</div>
                                <form action="${pageContext.request.contextPath}/my-library/reading-list/remove/${item.book.id}" method="post" style="margin-top:6px;">
                                    <button type="submit" class="btn btn-ghost btn-sm" style="padding-left:0; color:var(--danger);">Remove</button>
                                </form>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
