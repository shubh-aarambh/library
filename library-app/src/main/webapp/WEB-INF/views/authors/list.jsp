<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — Library Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
        <span class="brand-icon">📚</span>
        <span>Library Manager</span>
    </a>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/authors" class="active">👤 Authors</a></li>
        <li><a href="${pageContext.request.contextPath}/authors/new">➕ Add Author</a></li>
        <li><a href="${pageContext.request.contextPath}/books">📖 Books</a></li>
        <li><a href="${pageContext.request.contextPath}/books/new">➕ Add Book</a></li>
        <li><a href="${pageContext.request.contextPath}/books/joined">🔗 Joined View</a></li>
    </ul>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h1>${pageTitle}</h1>
            <p class="page-subtitle">Manage your author records below</p>
        </div>
        <a href="${pageContext.request.contextPath}/authors/new" class="btn btn-primary">➕ Add Author</a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">✅ ${successMessage}</div>
    </c:if>

    <div class="stats-bar">
        <span class="stat-chip">👤 ${authors.size()} Author(s) Found</span>
        <c:if test="${joinedView}">
            <span class="stat-chip">🔗 Inner Join Result — Only Authors With Books</span>
        </c:if>
    </div>

    <div class="card">
        <c:choose>
            <c:when test="${empty authors}">
                <div class="empty-state">
                    <div class="empty-state-icon">👤</div>
                    <h3>No Authors Found</h3>
                    <p>Start by adding your first author.</p>
                    <a href="${pageContext.request.contextPath}/authors/new" class="btn btn-primary" style="margin-top:1rem">➕ Add Author</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Nationality</th>
                                <th>Birth Year</th>
                                <th>Books</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="author" items="${authors}" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><strong>${author.name}</strong></td>
                                    <td><span class="badge">${author.nationality}</span></td>
                                    <td>${author.birthYear}</td>
                                    <td>${author.books.size()}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/authors/edit/${author.id}" class="btn btn-secondary btn-sm">✏️ Edit</a>
                                        <a href="${pageContext.request.contextPath}/authors/delete/${author.id}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Delete author ${author.name}? This will also delete all their books.')">🗑️ Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
