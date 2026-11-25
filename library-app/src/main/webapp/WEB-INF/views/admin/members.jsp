<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Member Directory — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">Member Directory (${members.size()})</h1>
        <p class="section-subtitle">Manage RBAC roles, membership tiers, borrowing quotas, and account access</p>
    </div>
</div>

<div class="card" style="padding:0;">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Member</th>
                    <th>Role</th>
                    <th>Tier &amp; Quota</th>
                    <th>Joined</th>
                    <th>Status</th>
                    <th>Role / Tier Update</th>
                    <th>Access</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${members}">
                    <tr>
                        <td>
                            <div style="display:flex; align-items:center; gap:10px;">
                                <span class="user-avatar">${m.initials}</span>
                                <div>
                                    <strong>${m.fullName}</strong>
                                    <div style="font-size:0.76rem; color:var(--text-muted);">${m.email}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="badge ${m.admin ? 'badge-violet' : 'badge-sky'}">${m.role}</span>
                        </td>
                        <td>
                            <span class="badge">${m.membershipTier}</span>
                            <div style="font-size:0.74rem; color:var(--text-muted); margin-top:2px;">Max ${m.borrowLimit} active loans</div>
                        </td>
                        <td style="font-size:0.84rem;">${m.formattedJoinedDate}</td>
                        <td>
                            <span class="badge ${m.active ? 'badge-emerald' : 'badge-danger'}">${m.active ? 'Active' : 'Suspended'}</span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/members/update/${m.id}" method="post" style="display:flex; gap:6px; align-items:center;">
                                <select name="role" class="filter-select" style="padding:5px 8px; font-size:0.78rem;">
                                    <option value="MEMBER" ${m.role == 'MEMBER' ? 'selected' : ''}>MEMBER</option>
                                    <option value="ADMIN" ${m.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                </select>
                                <select name="tier" class="filter-select" style="padding:5px 8px; font-size:0.78rem;">
                                    <option value="STANDARD" ${m.membershipTier == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                                    <option value="SCHOLAR" ${m.membershipTier == 'SCHOLAR' ? 'selected' : ''}>SCHOLAR</option>
                                    <option value="VIP" ${m.membershipTier == 'VIP' ? 'selected' : ''}>VIP</option>
                                </select>
                                <button type="submit" class="btn btn-gold-outline btn-sm">Save</button>
                            </form>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/members/toggle/${m.id}" method="post">
                                <button type="submit" class="btn btn-sm ${m.active ? 'btn-danger' : 'btn-emerald'}">
                                    ${m.active ? 'Suspend' : 'Activate'}
                                </button>
                            </form>
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

