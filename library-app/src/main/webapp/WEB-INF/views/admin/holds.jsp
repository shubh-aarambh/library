<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Waitlist &amp; Holds Queue — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:2rem;">Waitlist &amp; Holds Queue</h1>
        <p class="section-subtitle">Manage reader holds — returning a checked-out copy automatically promotes the next member to READY</p>
    </div>
    <div style="display:flex; gap:8px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/holds?status=ALL" class="btn btn-sm ${selectedStatus == 'ALL' ? 'btn-dark' : 'btn-secondary'}">All</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=READY" class="btn btn-sm ${selectedStatus == 'READY' ? 'btn-emerald' : 'btn-secondary'}">Ready (${stats.readyHolds})</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=WAITING" class="btn btn-sm ${selectedStatus == 'WAITING' ? 'btn-gold-outline' : 'btn-secondary'}">Waiting (${stats.waitingHolds})</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=FULFILLED" class="btn btn-sm ${selectedStatus == 'FULFILLED' ? 'btn-dark' : 'btn-secondary'}">Fulfilled</a>
    </div>
</div>

<div class="card" style="padding:0;">
    <c:choose>
        <c:when test="${empty holds}">
            <div class="empty-state">
                <h3>No Hold Requests in This View</h3>
                <p>When members join the waitlist for a checked-out book, their requests appear here in FIFO order.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Hold ID</th>
                            <th>Book &amp; Shelf Stock</th>
                            <th>Member</th>
                            <th>Requested</th>
                            <th>Status</th>
                            <th>Desk Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${holds}">
                            <tr>
                                <td class="mono" style="color:var(--text-muted);">#${h.id}</td>
                                <td>
                                    <strong>${h.book.title}</strong>
                                    <div class="mono" style="font-size:0.74rem; color:var(--text-muted);">
                                        Shelf ${h.book.shelfLocation} · ${h.book.availableCopies}/${h.book.totalCopies} avail
                                    </div>
                                </td>
                                <td>
                                    <div>${h.member.fullName}</div>
                                    <div style="font-size:0.75rem; color:var(--text-muted);">${h.member.email}</div>
                                </td>
                                <td>${h.formattedRequestedDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${h.status == 'READY'}"><span class="badge badge-emerald">Ready for Pickup</span></c:when>
                                        <c:when test="${h.status == 'WAITING'}"><span class="badge">Waiting in Queue</span></c:when>
                                        <c:when test="${h.status == 'FULFILLED'}"><span class="badge badge-sky">Fulfilled</span></c:when>
                                        <c:otherwise><span class="badge badge-neutral">${h.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="display:flex; gap:6px;">
                                        <c:if test="${(h.status == 'READY' || h.status == 'WAITING') && h.book.available}">
                                            <form action="${pageContext.request.contextPath}/admin/holds/fulfill/${h.id}" method="post">
                                                <button type="submit" class="btn btn-emerald btn-sm">Fulfill → Loan</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${h.status == 'READY' || h.status == 'WAITING'}">
                                            <form action="${pageContext.request.contextPath}/admin/holds/cancel/${h.id}" method="post">
                                                <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                            </form>
                                        </c:if>
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

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>

