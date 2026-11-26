<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Loans &amp; Returns — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Loans &amp; Returns Desk</h1>
        <p class="page-sub">Issue new loans, check in returns, extend due dates, and settle fines</p>
    </div>
    <div style="display:flex; gap:6px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/loans?status=ALL" class="btn btn-sm ${selectedStatus == 'ALL' ? 'btn-dark' : 'btn-secondary'}">All</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=ACTIVE" class="btn btn-sm ${selectedStatus == 'ACTIVE' ? 'btn-dark' : 'btn-secondary'}">Active (${stats.activeLoans})</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=OVERDUE" class="btn btn-sm ${selectedStatus == 'OVERDUE' ? 'btn-danger' : 'btn-secondary'}">Overdue (${stats.overdueLoans})</a>
        <a href="${pageContext.request.contextPath}/admin/loans?status=RETURNED" class="btn btn-sm ${selectedStatus == 'RETURNED' ? 'btn-dark' : 'btn-secondary'}">Returned</a>
    </div>
</div>

<div class="panel" style="margin-bottom:1.5rem;">
    <div style="font-weight:600; margin-bottom:0.85rem;">Issue New Loan</div>
    <form action="${pageContext.request.contextPath}/admin/loans/issue" method="post">
        <div class="form-grid-3">
            <div class="form-group" style="margin:0;">
                <label for="memberId">Member</label>
                <select name="memberId" id="memberId" class="form-control" required>
                    <c:forEach var="m" items="${members}">
                        <option value="${m.id}">${m.fullName} (${m.membershipTier})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin:0;">
                <label for="bookId">Available Book</label>
                <select name="bookId" id="bookId" class="form-control" required>
                    <c:forEach var="b" items="${availableBooks}">
                        <option value="${b.id}">${b.title} (${b.availableCopies} avail · ${b.shelfLocation})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin:0;">
                <label for="days">Days</label>
                <div style="display:flex; gap:8px;">
                    <input type="number" name="days" id="days" value="14" min="1" max="60" class="form-control" style="max-width:95px;">
                    <button type="submit" class="btn btn-primary" style="flex:1;">Issue loan</button>
                </div>
            </div>
        </div>
    </form>
</div>

<div class="panel" style="padding:0;">
    <div class="table-wrap">
        <table>
            <thead>
                <tr><th>Pass</th><th>Book</th><th>Borrower</th><th>Due Date</th><th>Status &amp; Fine</th><th></th></tr>
            </thead>
            <tbody>
                <c:forEach var="loan" items="${loans}">
                    <tr>
                        <td class="mono" style="font-size:0.8rem;">${loan.pickupCode}</td>
                        <td>
                            <strong>${loan.book.title}</strong>
                            <div class="mono" style="font-size:0.74rem; color:var(--ink-3);">Shelf ${loan.book.shelfLocation}</div>
                        </td>
                        <td>
                            <div>${loan.member.fullName}</div>
                            <div style="font-size:0.75rem; color:var(--ink-3);">${loan.member.email}</div>
                        </td>
                        <td class="mono" style="font-size:0.82rem;">${loan.formattedDueDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${loan.status == 'OVERDUE'}"><span class="tag tag-red">Overdue · ${loan.daysOverdue}d</span></c:when>
                                <c:when test="${loan.status == 'RETURNED'}"><span class="tag">Returned ${loan.formattedReturnedDate}</span></c:when>
                                <c:otherwise><span class="tag tag-green">Active · ${loan.daysRemaining}d left</span></c:otherwise>
                            </c:choose>
                            <c:if test="${loan.computedFine > 0}">
                                <div style="font-size:0.75rem; margin-top:3px; color:${loan.finePaid ? 'var(--accent)' : 'var(--danger)'}; font-weight:600;">
                                    Fine: $${loan.computedFine} ${loan.finePaid ? '(Paid)' : '(Unpaid)'}
                                </div>
                            </c:if>
                        </td>
                        <td style="text-align:right; white-space:nowrap;">
                            <c:if test="${loan.status != 'RETURNED'}">
                                <form action="${pageContext.request.contextPath}/admin/loans/return/${loan.id}" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-primary btn-sm">Check in</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/loans/renew/${loan.id}" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-secondary btn-sm">+7d</button>
                                </form>
                            </c:if>
                            <c:if test="${loan.computedFine > 0 && !loan.finePaid}">
                                <form action="${pageContext.request.contextPath}/admin/loans/pay-fine/${loan.id}" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-secondary btn-sm">Settle fine</button>
                                </form>
                            </c:if>
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
