<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Authors — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">Authors Registry (${authors.size()})</h1>
        <p class="section-subtitle">Manage author biographies, literary honors, and linked volumes</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/authors/new" class="btn btn-primary btn-sm">+ Add Author</a>
</div>

<form action="${pageContext.request.contextPath}/admin/authors" method="get" class="filter-bar">
    <div class="filter-search">
        <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <input type="text" name="q" value="${query}" data-quick-search placeholder="Search authors by name, nationality, or award...">
    </div>
    <button type="submit" class="btn btn-primary btn-sm">Search</button>
</form>

<div class="card" style="padding:0;">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Author</th>
                    <th>Nationality</th>
                    <th>Birth Year</th>
                    <th>Notable Distinction</th>
                    <th>Volumes</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="author" items="${authors}">
                    <tr>
                        <td>
                            <div style="display:flex; align-items:center; gap:10px;">
                                <span class="author-monogram" style="width:36px; height:36px; font-size:0.85rem; border-radius:9px; background:${author.avatarColor};">
                                    ${author.initials}
                                </span>
                                <strong>${author.name}</strong>
                            </div>
                        </td>
                        <td><span class="badge badge-neutral">${author.nationality}</span></td>
                        <td>${author.birthYear}</td>
                        <td style="font-size:0.84rem; color:var(--text-soft);">${not empty author.notableAward ? author.notableAward : '—'}</td>
                        <td><span class="badge">${author.books.size()}</span></td>
                        <td>
                            <div style="display:flex; gap:6px;">
                                <a href="${pageContext.request.contextPath}/authors/${author.id}" class="btn btn-secondary btn-sm" target="_blank">Profile</a>
                                <a href="${pageContext.request.contextPath}/admin/authors/edit/${author.id}" class="btn btn-gold-outline btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/authors/delete/${author.id}" method="post"
                                      onsubmit="return confirm('Delete this author and cascade delete their linked books?')">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
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

