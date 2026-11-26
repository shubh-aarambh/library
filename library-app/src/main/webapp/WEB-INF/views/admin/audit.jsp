<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Activity Log — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Activity Log (${logs.size()})</h1>
        <p class="page-sub">Chronological ledger of circulation, catalog, and staff actions</p>
    </div>
    <div style="display:flex; gap:6px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/audit?category=ALL" class="btn btn-sm ${selectedCategory == 'ALL' ? 'btn-dark' : 'btn-secondary'}">All</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=CIRCULATION" class="btn btn-sm ${selectedCategory == 'CIRCULATION' ? 'btn-dark' : 'btn-secondary'}">Circulation</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=CATALOG" class="btn btn-sm ${selectedCategory == 'CATALOG' ? 'btn-dark' : 'btn-secondary'}">Catalog</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=MEMBER" class="btn btn-sm ${selectedCategory == 'MEMBER' ? 'btn-dark' : 'btn-secondary'}">Members</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=SYSTEM" class="btn btn-sm ${selectedCategory == 'SYSTEM' ? 'btn-dark' : 'btn-secondary'}">System</a>
    </div>
</div>

<div class="panel" style="padding:0;">
    <div class="table-wrap">
        <table>
            <thead><tr><th>Time</th><th>Category</th><th>Event</th><th>Actor</th><th>Details</th></tr></thead>
            <tbody>
                <c:forEach var="log" items="${logs}">
                    <tr>
                        <td class="mono" style="font-size:0.78rem; color:var(--ink-3);">${log.formattedTime}</td>
                        <td><span class="tag">${log.category}</span></td>
                        <td class="mono" style="font-size:0.78rem;">${log.action}</td>
                        <td><strong>${log.actorName}</strong></td>
                        <td style="color:var(--ink-2);">${log.details}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>
