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
        <div class="section-header">
            <div>
                <div class="section-kicker">Member Reading Desk</div>
                <h1 class="section-title">Welcome, ${member.fullName}</h1>
                <p class="section-subtitle">${member.email} · ${member.membershipTier} Tier (Limit: ${member.borrowLimit} active books)</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Browse Catalog</a>
                <c:if test="${member.admin}">
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-gold-outline btn-sm">Open Admin Console ↗</a>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
        </c:if>

        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-label">Active Borrowings</div>
                <div class="kpi-num">${activeLoans.size()} / ${member.borrowLimit}</div>
                <div class="kpi-meta">${member.membershipTier} tier quota</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-label">Saved Reading List</div>
                <div class="kpi-num">${readingList.size()}</div>
                <div class="kpi-meta">Bookmarked volumes</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-label">Completed Reads</div>
                <div class="kpi-num">${pastLoans.size()}</div>
                <div class="kpi-meta">Returned to Athenaeum</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-label">Member Since</div>
                <div class="kpi-num" style="font-size:1.35rem; margin-top:12px;">${member.formattedJoinedDate}</div>
                <div class="kpi-meta">Card status: Active</div>
            </div>
        </div>

        <!-- Active Loans -->
        <div class="card" style="margin-bottom:2rem;">
            <div class="section-header" style="margin-bottom:1.25rem;">
                <div>
                    <div class="section-kicker">Currently Checked Out</div>
                    <h2 class="serif" style="font-size:1.5rem;">Active Loans (${activeLoans.size()})</h2>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty activeLoans}">
                    <div class="empty-state" style="padding:2.25rem 1rem;">
                        <h3>No Active Borrowings</h3>
                        <p style="margin-bottom:1rem;">Explore the catalog and borrow your next read with a single click.</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm">Discover Books</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>Book</th>
                                    <th>Borrowed On</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="loan" items="${activeLoans}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/${loan.book.id}" style="font-weight:700;">${loan.book.title}</a>
                                            <div style="font-size:0.78rem; color:var(--text-muted);">${loan.book.author.name} · Shelf ${loan.book.shelfLocation}</div>
                                        </td>
                                        <td>${loan.formattedBorrowedDate}</td>
                                        <td class="mono">${loan.formattedDueDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${loan.status == 'OVERDUE'}">
                                                    <span class="badge badge-danger">Overdue · $${loan.computedFine}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-emerald">${loan.daysRemaining} day(s) left</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display:flex; gap:8px;">
                                                <form action="${pageContext.request.contextPath}/my-library/renew/${loan.id}" method="post">
                                                    <button type="submit" class="btn btn-secondary btn-sm">Renew +7d</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/my-library/return/${loan.id}" method="post">
                                                    <button type="submit" class="btn btn-emerald btn-sm">Return Book</button>
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

        <!-- Reading List -->
        <div class="card" style="margin-bottom:2rem;">
            <div class="section-header" style="margin-bottom:1.25rem;">
                <div>
                    <div class="section-kicker">Saved For Later</div>
                    <h2 class="serif" style="font-size:1.5rem;">My Reading List (${readingList.size()})</h2>
                </div>
            </div>
            <c:choose>
                <c:when test="${empty readingList}">
                    <div class="empty-state" style="padding:2rem 1rem;">
                        <p>Bookmark any book from the catalog to build your personal queue.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="books-grid">
                        <c:forEach var="item" items="${readingList}">
                            <article class="book-card">
                                <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="book-cover" style="background:${item.book.coverColor}; height:175px;">
                                    <div class="book-cover-top">
                                        <span class="cover-genre">${item.book.genre}</span>
                                        <span class="cover-rating">★ ${item.book.rating}</span>
                                    </div>
                                    <div>
                                        <div class="book-cover-title">${item.book.title}</div>
                                        <div class="book-cover-author">${item.book.author.name}</div>
                                    </div>
                                </a>
                                <div class="book-body">
                                    <div style="display:flex; gap:8px;">
                                        <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="btn btn-primary btn-sm" style="flex:1;">Open Book</a>
                                        <form action="${pageContext.request.contextPath}/my-library/reading-list/remove/${item.book.id}" method="post">
                                            <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                        </form>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Borrowing History -->
        <c:if test="${not empty pastLoans}">
            <div class="card">
                <div class="section-kicker">Archive</div>
                <h2 class="serif" style="font-size:1.4rem; margin-bottom:1rem;">Borrowing History</h2>
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
                                    <td><span class="badge badge-neutral">Returned</span></td>
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

