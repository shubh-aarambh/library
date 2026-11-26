<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Library — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
        </c:if>

        <!-- Digital Library Card + 2026 Annual Reading Goal -->
        <div class="dashboard-split" style="margin-bottom:2rem;">
            <div class="library-card-visual">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:1rem;">
                    <div>
                        <div style="font-size:0.68rem; text-transform:uppercase; letter-spacing:0.15em; color:#f6c478; font-weight:800;">Athenaeum Digital Library Card</div>
                        <div class="serif" style="font-size:2rem; line-height:1.1; margin-top:4px;">${member.fullName}</div>
                        <div style="font-size:0.83rem; opacity:0.78;">${member.email}</div>
                    </div>
                    <!-- Crisp SVG QR Pass -->
                    <div class="qr-box" title="Scan at Library Kiosk: ${member.libraryCardNumber}">
                        <svg viewBox="0 0 29 29" width="56" height="56" shape-rendering="crispEdges">
                            <rect width="29" height="29" fill="#fff"/>
                            <path fill="#141923" d="M2 2h7v7H2zM3 3v5h5V3zM4 4h3v3H4zM20 2h7v7h-7zM21 3v5h5V3zM22 4h3v3h-3zM2 20h7v7H2zM3 21v5h5v-5zM4 22h3v3H4zM11 2h2v2h-2zM15 2h2v3h-2zM11 6h4v2h-4zM17 6h2v4h-2zM2 11h3v2H2zM7 11h4v2H7zM13 11h3v4h-3zM19 11h2v2h-2zM23 11h4v2h-4zM4 15h3v3H4zM9 15h2v3H9zM17 15h4v2h-4zM23 15h2v4h-2zM11 19h2v4h-2zM15 19h3v2h-3zM20 19h3v3h-3zM25 21h2v4h-2zM14 23h4v4h-4zM20 24h3v3h-3z"/>
                        </svg>
                    </div>
                </div>

                <div style="display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:1rem; margin-top:1.25rem; padding-top:1rem; border-top:1px solid rgba(255,255,255,0.14);">
                    <div>
                        <div style="font-size:0.65rem; text-transform:uppercase; letter-spacing:0.12em; opacity:0.65;">Card Number</div>
                        <div class="mono" style="font-size:0.95rem; font-weight:700; color:#f6c478;">${member.libraryCardNumber}</div>
                    </div>
                    <div>
                        <div style="font-size:0.65rem; text-transform:uppercase; letter-spacing:0.12em; opacity:0.65;">Tier &amp; Quota</div>
                        <div style="font-size:0.9rem; font-weight:700;">${member.membershipTier} · ${activeLoans.size()}/${member.borrowLimit} Loans</div>
                    </div>
                    <div>
                        <div style="font-size:0.65rem; text-transform:uppercase; letter-spacing:0.12em; opacity:0.65;">Member Since</div>
                        <div style="font-size:0.86rem;">${member.formattedJoinedDate}</div>
                    </div>
                </div>
            </div>

            <!-- 2026 Reading Challenge & Quick Actions -->
            <div class="card" style="display:flex; flex-direction:column; justify-content:space-between; gap:1rem;">
                <div>
                    <div class="section-kicker">2026 Reading Challenge</div>
                    <div style="display:flex; justify-content:space-between; align-items:baseline;">
                        <h2 class="serif" style="font-size:1.85rem;">${pastLoans.size()} of ${member.annualReadingGoal} Books Completed</h2>
                        <span class="badge">${goalPercent}%</span>
                    </div>
                    <div class="availability-bar" style="height:10px; margin:0.85rem 0 0.5rem;">
                        <div class="progress-fill" style="width:${goalPercent}%;"></div>
                    </div>
                    <p style="font-size:0.84rem; color:var(--text-soft);">
                        Currently reading <strong>${activeLoans.size()}</strong> title(s) · <strong>${activeHolds.size()}</strong> active waitlist hold(s) · <strong>${readingList.size()}</strong> saved.
                    </p>
                </div>

                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px; padding-top:0.85rem; border-top:1px solid var(--border);">
                    <form action="${pageContext.request.contextPath}/my-library/goal" method="post" style="display:flex; align-items:center; gap:8px;">
                        <label for="goal" style="font-size:0.78rem; font-weight:700; color:var(--text-muted);">Annual Goal:</label>
                        <input type="number" id="goal" name="goal" value="${member.annualReadingGoal}" min="1" max="200" class="filter-select" style="width:78px; padding:6px 10px;">
                        <button type="submit" class="btn btn-secondary btn-sm">Update</button>
                    </form>
                    <div style="display:flex; gap:8px;">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Find Next Book</a>
                        <c:if test="${member.admin}">
                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-dark btn-sm">Admin Console ↗</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Active Loans with Reading Progress Tracker & Pickup Pass -->
        <div class="card" style="margin-bottom:2rem;">
            <div class="section-header" style="margin-bottom:1.1rem;">
                <div>
                    <div class="section-kicker">Currently Reading &amp; Checked Out</div>
                    <h2 class="serif" style="font-size:1.75rem;">Active Loans (${activeLoans.size()})</h2>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty activeLoans}">
                    <div class="empty-state" style="padding:2rem 1rem;">
                        <h3>Your Shelf Is Clear</h3>
                        <p style="margin-bottom:1rem;">Borrow any available book to generate a digital pickup pass and track reading progress.</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Browse Catalog</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap:1rem;">
                        <c:forEach var="loan" items="${activeLoans}">
                            <div style="display:grid; grid-template-columns:72px 1fr auto; gap:1.25rem; align-items:center; padding:1rem; border:1px solid var(--border); border-radius:14px; background:var(--bg-subtle);">
                                <a href="${pageContext.request.contextPath}/books/${loan.book.id}" class="real-cover" style="height:102px; width:70px; aspect-ratio:auto; padding:6px; background:${loan.book.coverColor};">
                                    <c:if test="${not empty loan.book.resolvedCoverUrl}">
                                        <img class="real-cover-img" src="${loan.book.resolvedCoverUrl}" alt="${loan.book.title}" onerror="this.style.display='none'">
                                    </c:if>
                                </a>

                                <div>
                                    <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px; margin-bottom:3px;">
                                        <a href="${pageContext.request.contextPath}/books/${loan.book.id}" class="serif" style="font-size:1.4rem; line-height:1.15;">${loan.book.title}</a>
                                        <span class="badge badge-neutral mono">Pass ${loan.pickupCode}</span>
                                        <c:choose>
                                            <c:when test="${loan.status == 'OVERDUE'}">
                                                <span class="badge badge-danger">Overdue · $${loan.computedFine}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-emerald">${loan.daysRemaining}d left (Due ${loan.formattedDueDate})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="font-size:0.82rem; color:var(--text-muted); margin-bottom:0.75rem;">
                                        ${loan.book.author.name} · Shelf ${loan.book.shelfLocation} · ${loan.book.formattedReadingTime}
                                    </div>

                                    <!-- Interactive Reading Progress Slider -->
                                    <form action="${pageContext.request.contextPath}/my-library/progress/${loan.id}" method="post" style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                        <span style="font-size:0.76rem; font-weight:700; color:var(--text-soft);">Reading Progress:</span>
                                        <input type="range" name="progress" min="0" max="100" step="5" value="${loan.readingProgress}"
                                               oninput="this.nextElementSibling.textContent = this.value + '%'"
                                               style="accent-color:var(--accent); width:170px; cursor:pointer;">
                                        <strong class="mono" style="font-size:0.82rem; min-width:38px; color:var(--accent);">${loan.readingProgress}%</strong>
                                        <button type="submit" class="btn btn-secondary btn-sm">Save Progress</button>
                                    </form>
                                </div>

                                <div style="display:flex; flex-direction:column; gap:6px;">
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${loan.book.id})">Reader Guide</button>
                                    <form action="${pageContext.request.contextPath}/my-library/renew/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-secondary btn-sm btn-block">Renew +7d</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/my-library/return/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-emerald btn-sm btn-block">Return Book</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Waitlist Holds Queue -->
        <div class="card" style="margin-bottom:2rem;">
            <div class="section-header" style="margin-bottom:1rem;">
                <div>
                    <div class="section-kicker">Automatic Hold Notifications</div>
                    <h2 class="serif" style="font-size:1.7rem;">My Waitlist Holds (${activeHolds.size()})</h2>
                </div>
            </div>
            <c:choose>
                <c:when test="${empty activeHolds}">
                    <p style="color:var(--text-muted); font-size:0.88rem;">You have no active waitlist holds. When a popular title has 0 copies on shelf, join its waitlist from the book page.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Requested</th>
                                    <th>Queue Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${activeHolds}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/${h.book.id}" style="font-weight:700;">${h.book.title}</a>
                                            <div style="font-size:0.77rem; color:var(--text-muted);">${h.book.author.name}</div>
                                        </td>
                                        <td>${h.formattedRequestedDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${h.status == 'READY'}">
                                                    <span class="badge badge-emerald">Ready for Pickup!</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge">Waiting in Queue</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display:flex; gap:6px;">
                                                <c:if test="${h.status == 'READY'}">
                                                    <a href="${pageContext.request.contextPath}/books/${h.book.id}" class="btn btn-primary btn-sm">Borrow Now</a>
                                                </c:if>
                                                <form action="${pageContext.request.contextPath}/my-library/holds/cancel/${h.id}" method="post">
                                                    <button type="submit" class="btn btn-danger btn-sm">Cancel Hold</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Saved Reading List -->
        <div class="card" style="margin-bottom:2rem;">
            <div class="section-header" style="margin-bottom:1.1rem;">
                <div>
                    <div class="section-kicker">Saved For Later</div>
                    <h2 class="serif" style="font-size:1.7rem;">My Reading List (${readingList.size()})</h2>
                </div>
            </div>
            <c:choose>
                <c:when test="${empty readingList}">
                    <p style="color:var(--text-muted); font-size:0.88rem;">Bookmark titles from the catalog to build your next-up reading queue.</p>
                </c:when>
                <c:otherwise>
                    <div class="books-grid">
                        <c:forEach var="item" items="${readingList}">
                            <article class="book-tile">
                                <div class="book-tile-cover-wrap">
                                    <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="real-cover" style="background:${item.book.coverColor};">
                                        <c:if test="${not empty item.book.resolvedCoverUrl}">
                                            <img class="real-cover-img" src="${item.book.resolvedCoverUrl}" alt="${item.book.title}" loading="lazy" onerror="this.style.display='none'">
                                        </c:if>
                                        <div class="cover-fallback">
                                            <span style="font-size:0.7rem;">${item.book.genre}</span>
                                            <div class="cover-fallback-title">${item.book.title}</div>
                                        </div>
                                    </a>
                                </div>
                                <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="book-tile-title">${item.book.title}</a>
                                <div class="book-tile-author">${item.book.author.name}</div>
                                <div class="book-tile-footer">
                                    <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="btn btn-primary btn-sm" style="flex:1;">Open</a>
                                    <form action="${pageContext.request.contextPath}/my-library/reading-list/remove/${item.book.id}" method="post">
                                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                    </form>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Completed History -->
        <c:if test="${not empty pastLoans}">
            <div class="card">
                <div class="section-kicker">Completed Reads</div>
                <h2 class="serif" style="font-size:1.65rem; margin-bottom:1rem;">Borrowing History (${pastLoans.size()})</h2>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Book</th>
                                <th>Borrowed</th>
                                <th>Returned</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="loan" items="${pastLoans}">
                                <tr>
                                    <td><a href="${pageContext.request.contextPath}/books/${loan.book.id}" style="font-weight:700;">${loan.book.title}</a></td>
                                    <td>${loan.formattedBorrowedDate}</td>
                                    <td>${loan.formattedReturnedDate}</td>
                                    <td><span class="badge badge-neutral">Completed</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
