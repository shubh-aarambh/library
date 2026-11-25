<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Circulation &amp; Loans — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">Circulation &amp; Loans Desk</h1>
        <p class="section-subtitle">Issue new loans, process returns, extend due dates, and settle overdue fines</p>
    </div>
    <div style="display:flex; gap:8px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/loans?status=ALL" class="btn btn-sm ${selectedStatus == 'ALL' ? 'btn-gold-outline' : 'btn-secondary'}">All (${stats.openLoans + stats.returnedLoans})</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=ACTIVE" class="btn btn-sm ${selectedStatus == 'ACTIVE' ? 'btn-gold-outline' : 'btn-secondary'}">Active (${stats.activeLoans})</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=OVERDUE" class="btn btn-sm ${selectedStatus == 'OVERDUE' ? 'btn-danger' : 'btn-secondary'}">Overdue (${stats.overdueLoans})</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=RETURNED" class="btn btn-sm ${selectedStatus == 'RETURNED' ? 'btn-gold-outline' : 'btn-secondary'}">Returned (${stats.returnedLoans})</a>
    </div>
</div>

<!-- Quick Manual Issue Loan Card -->
<div class="card" style="margin-bottom:1.75rem;">
    <div class="section-kicker">Front Desk Checkout</div>
    <h2 class="serif" style="font-size:1.25rem; margin-bottom:1rem;">Issue New Loan</h2>
    <form action="${pageContext.request.contextPath}/admin/loans/issue" method="post">
        <div class="form-grid-3">
            <div class="form-group" style="margin-bottom:0;">
                <label for="memberId">Member</label>
                <select name="memberId" id="memberId" class="form-control" required>
                    <c:forEach var="m" items="${members}">
                        <option value="${m.id}">${m.fullName} (${m.membershipTier})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin-bottom:0;">
                <label for="bookId">Available Volume</label>
                <select name="bookId" id="bookId" class="form-control" required>
                    <c:forEach var="b" items="${availableBooks}">
                        <option value="${b.id}">${b.title} (${b.availableCopies} avail · ${b.shelfLocation})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin-bottom:0;">
                <label for="days">Loan Window (Days)</label>
                <div style="display:flex; gap:8px;">
                    <input type="number" name="days" id="days" value="14" min="1" max="60" class="form-control" style="max-width:110px;">
                    <button type="submit" class="btn btn-primary" style="flex:1;">Issue Loan</button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Loans Ledger -->
<div class="card" style="padding:0;">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Volume</th>
                    <th>Borrower</th>
                    <th>Borrowed</th>
                    <th>Due Date</th>
                    <th>Status &amp; Fine</th>
                    <th>Desk Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="loan" items="${loans}">
                    <tr>
                        <td class="mono" style="color:var(--text-muted);">#${loan.id}</td>
                        <td>
                            <strong>${loan.book.title}</strong>
                            <div class="mono" style="font-size:0.74rem; color:var(--text-muted);">Shelf ${loan.book.shelfLocation}</div>
                        </td>
                        <td>
                            <div>${loan.member.fullName}</div>
                            <div style="font-size:0.74rem; color:var(--text-muted);">${loan.member.email}</div>
                        </td>
                        <td>${loan.formattedBorrowedDate}</td>
                        <td class="mono" style="font-size:0.82rem;">${loan.formattedDueDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${loan.status == 'OVERDUE'}">
                                    <span class="badge badge-danger">Overdue · ${loan.daysOverdue}d</span>
                                </c:when>
                                <c:when test="${loan.status == 'RETURNED'}">
                                    <span class="badge badge-neutral">Returned ${loan.formattedReturnedDate}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-emerald">Active · ${loan.daysRemaining}d left</span>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${loan.computedFine > 0}">
                                <div style="margin-top:4px; font-size:0.75rem; font-weight:700; color:${loan.finePaid ? 'var(--emerald)' : 'var(--danger)'};">
                                    Fine: $${loan.computedFine} ${loan.finePaid ? '(Paid)' : '(Unpaid)'}
                                </div>
                            </c:if>
                        </td>
                        <td>
                            <div style="display:flex; gap:6px; flex-wrap:wrap;">
                                <c:if test="${loan.status != 'RETURNED'}">
                                    <form action="${pageContext.request.contextPath}/admin/loans/return/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-emerald btn-sm">Check In</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/loans/renew/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-secondary btn-sm">+7d</button>
                                    </form>
                                </c:if>
                                <c:if test="${loan.computedFine > 0 && !loan.finePaid}">
                                    <form action="${pageContext.request.contextPath}/admin/loans/pay-fine/${loan.id}" method="post">
                                        <button type="submit" class="btn btn-gold-outline btn-sm">Settle Fine</button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>

