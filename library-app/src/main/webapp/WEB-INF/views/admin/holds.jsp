<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Waitlist Holds — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Waitlist Holds Queue</h1>
        <p class="page-sub">Returning a book automatically promotes the next waiting member to Ready</p>
    </div>
    <div style="display:flex; gap:6px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/holds?status=ALL" class="btn btn-sm ${selectedStatus == 'ALL' ? 'btn-dark' : 'btn-secondary'}">All</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=READY" class="btn btn-sm ${selectedStatus == 'READY' ? 'btn-primary' : 'btn-secondary'}">Ready (${stats.readyHolds})</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=WAITING" class="btn btn-sm ${selectedStatus == 'WAITING' ? 'btn-dark' : 'btn-secondary'}">Waiting (${stats.waitingHolds})</a>
        <a href="${pageContext.request.contextPath}/admin/holds?status=FULFILLED" class="btn btn-sm ${selectedStatus == 'FULFILLED' ? 'btn-dark' : 'btn-secondary'}">Fulfilled</a>
    </div>
</div>

<div class="panel" style="padding:0;">
    <c:choose>
        <c:when test="${empty holds}">
            <div class="empty-state"><h3>No hold requests</h3><p>Member waitlist requests will appear here.</p></div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr><th>ID</th><th>Book &amp; Stock</th><th>Member</th><th>Requested</th><th>Status</th><th></th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${holds}">
                            <tr>
                                <td class="mono" style="color:var(--ink-3);">#${h.id}</td>
                                <td>
                                    <strong>${h.book.title}</strong>
                                    <div class="mono" style="font-size:0.74rem; color:var(--ink-3);">Shelf ${h.book.shelfLocation} · ${h.book.availableCopies}/${h.book.totalCopies} avail</div>
                                </td>
                                <td>${h.member.fullName} <div style="font-size:0.75rem; color:var(--ink-3);">${h.member.email}</div></td>
                                <td>${h.formattedRequestedDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${h.status == 'READY'}"><span class="tag tag-green">Ready</span></c:when>
                                        <c:when test="${h.status == 'WAITING'}"><span class="tag tag-amber">Waiting</span></c:when>
                                        <c:otherwise><span class="tag">${h.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align:right; white-space:nowrap;">
                                    <c:if test="${(h.status == 'READY' || h.status == 'WAITING') && h.book.available}">
                                        <form action="${pageContext.request.contextPath}/admin/holds/fulfill/${h.id}" method="post" style="display:inline;">
                                            <button type="submit" class="btn btn-primary btn-sm">Fulfill → Loan</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${h.status == 'READY' || h.status == 'WAITING'}">
                                        <form action="${pageContext.request.contextPath}/admin/holds/cancel/${h.id}" method="post" style="display:inline;">
                                            <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                        </form>
                                    </c:if>
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
