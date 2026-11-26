<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Authors — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="page-top" style="padding-bottom:1rem; margin-bottom:1.25rem;">
    <div>
        <h1 class="page-title" style="font-size:1.65rem;">Authors (${authors.size()})</h1>
        <p class="page-sub">Maintain author biographies and linked books</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/authors/new" class="btn btn-primary btn-sm">Add author</a>
</div>

<form action="${pageContext.request.contextPath}/admin/authors" method="get" class="filter-strip">
    <input type="text" name="q" value="${query}" class="input" style="flex:1 1 240px;" placeholder="Search authors...">
    <button type="submit" class="btn btn-secondary btn-sm">Filter</button>
</form>

<div class="panel" style="padding:0;">
    <div class="table-wrap">
        <table>
            <thead><tr><th>Author</th><th>Nationality</th><th>Born</th><th>Award</th><th>Books</th><th></th></tr></thead>
            <tbody>
                <c:forEach var="author" items="${authors}">
                    <tr>
                        <td><strong>${author.name}</strong></td>
                        <td>${author.nationality}</td>
                        <td>${author.birthYear}</td>
                        <td style="font-size:0.84rem; color:var(--ink-2);">${not empty author.notableAward ? author.notableAward : '—'}</td>
                        <td class="mono">${author.books.size()}</td>
                        <td style="text-align:right; white-space:nowrap;">
                            <a href="${pageContext.request.contextPath}/admin/authors/edit/${author.id}" class="btn btn-secondary btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/authors/delete/${author.id}" method="post" style="display:inline;"
                                  onsubmit="return confirm('Delete this author and cascade delete their linked books?')">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
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
