<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>System Audit Trail — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">System Audit Trail (${logs.size()})</h1>
        <p class="section-subtitle">Chronological telemetry across circulation, catalog edits, member signups, and admin actions</p>
    </div>
    <div style="display:flex; gap:8px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/admin/audit?category=ALL" class="btn btn-sm ${selectedCategory == 'ALL' ? 'btn-gold-outline' : 'btn-secondary'}">All</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=CIRCULATION" class="btn btn-sm ${selectedCategory == 'CIRCULATION' ? 'btn-gold-outline' : 'btn-secondary'}">Circulation</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=CATALOG" class="btn btn-sm ${selectedCategory == 'CATALOG' ? 'btn-gold-outline' : 'btn-secondary'}">Catalog</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=MEMBER" class="btn btn-sm ${selectedCategory == 'MEMBER' ? 'btn-gold-outline' : 'btn-secondary'}">Members</a>
        <a href="${pageContext.request.contextPath}/admin/audit?category=SYSTEM" class="btn btn-sm ${selectedCategory == 'SYSTEM' ? 'btn-gold-outline' : 'btn-secondary'}">System</a>
    </div>
</div>

<div class="card" style="padding:0;">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Category</th>
                    <th>Event</th>
                    <th>Actor</th>
                    <th>Details</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${logs}">
                    <tr>
                        <td class="mono" style="font-size:0.78rem; color:var(--text-muted);">${log.formattedTime}</td>
                        <td>
                            <span class="badge ${log.category == 'CIRCULATION' ? 'badge-sky' : (log.category == 'CATALOG' ? 'badge-emerald' : (log.category == 'MEMBER' ? 'badge-violet' : 'badge-neutral'))}">
                                ${log.category}
                            </span>
                        </td>
                        <td class="mono" style="font-size:0.78rem; color:var(--gold);">${log.action}</td>
                        <td><strong>${log.actorName}</strong></td>
                        <td style="color:var(--text-soft);">${log.details}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>

