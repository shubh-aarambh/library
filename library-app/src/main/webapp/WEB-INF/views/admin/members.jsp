<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Members — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Members (${members.size()})</h1>
        <p class="page-sub">Manage library card roles, membership tiers, and account status</p>
    </div>
</div>

<div class="panel" style="padding:0;">
    <div class="table-wrap">
        <table>
            <thead><tr><th>Member</th><th>Card ID</th><th>Role &amp; Tier</th><th>Status</th><th>Update</th><th></th></tr></thead>
            <tbody>
                <c:forEach var="m" items="${members}">
                    <tr>
                        <td>
                            <strong>${m.fullName}</strong>
                            <div style="font-size:0.76rem; color:var(--ink-3);">${m.email}</div>
                        </td>
                        <td class="mono" style="font-size:0.8rem;">${m.libraryCardNumber}</td>
                        <td><span class="tag">${m.role}</span> <span class="tag tag-green">${m.membershipTier}</span></td>
                        <td><span class="tag ${m.active ? 'tag-green' : 'tag-red'}">${m.active ? 'Active' : 'Suspended'}</span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/members/update/${m.id}" method="post" style="display:flex; gap:5px;">
                                <select name="role" class="select" style="padding:4px 8px; font-size:0.78rem;">
                                    <option value="MEMBER" ${m.role == 'MEMBER' ? 'selected' : ''}>MEMBER</option>
                                    <option value="ADMIN" ${m.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                </select>
                                <select name="tier" class="select" style="padding:4px 8px; font-size:0.78rem;">
                                    <option value="STANDARD" ${m.membershipTier == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                                    <option value="SCHOLAR" ${m.membershipTier == 'SCHOLAR' ? 'selected' : ''}>SCHOLAR</option>
                                    <option value="VIP" ${m.membershipTier == 'VIP' ? 'selected' : ''}>VIP</option>
                                </select>
                                <button type="submit" class="btn btn-secondary btn-sm">Save</button>
                            </form>
                        </td>
                        <td style="text-align:right;">
                            <form action="${pageContext.request.contextPath}/admin/members/toggle/${m.id}" method="post">
                                <button type="submit" class="btn btn-sm ${m.active ? 'btn-danger' : 'btn-primary'}">${m.active ? 'Suspend' : 'Activate'}</button>
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
