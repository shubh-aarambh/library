<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="section-header">
            <div>
                <div class="section-kicker">Literary Directory</div>
                <h1 class="section-title">${pageTitle}</h1>
                <p class="section-subtitle">Showing ${authors.size()} author profile(s) in the Athenaeum archive</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
                <c:choose>
                    <c:when test="${joinedView}">
                        <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">Show All Authors</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/authors/with-books" class="btn btn-gold-outline btn-sm">Only With Books (Inner Join)</a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/authors/new" class="btn btn-primary btn-sm">+ Add Author</a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
        </c:if>

        <form action="${pageContext.request.contextPath}${joinedView ? '/authors/with-books' : '/authors'}" method="get" class="filter-bar">
            <div class="filter-search">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" name="q" value="${query}" data-quick-search placeholder="Search authors by name, nationality, or award...">
            </div>

            <select name="nationality" class="filter-select" onchange="this.form.submit()">
                <option value="ALL" ${selectedNationality == 'ALL' ? 'selected' : ''}>All Nationalities</option>
                <c:forEach var="nat" items="${nationalities}">
                    <option value="${nat}" ${selectedNationality == nat ? 'selected' : ''}>${nat}</option>
                </c:forEach>
            </select>

            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
        </form>

        <c:choose>
            <c:when test="${empty authors}">
                <div class="card empty-state">
                    <h3>No Authors Found</h3>
                    <p style="margin-bottom:1.25rem;">Try resetting filters or register a new author profile.</p>
                    <a href="${pageContext.request.contextPath}/authors/new" class="btn btn-primary btn-sm">+ Add Author</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="authors-grid">
                    <c:forEach var="author" items="${authors}">
                        <article class="author-card">
                            <div class="author-header">
                                <div class="author-monogram" style="background:${author.avatarColor};">${author.initials}</div>
                                <div style="flex:1; min-width:0;">
                                    <a href="${pageContext.request.contextPath}/authors/${author.id}" style="font-size:1.1rem; font-weight:700; display:block;">${author.name}</a>
                                    <div style="font-size:0.8rem; color:var(--text-muted);">${author.nationality} · Born ${author.birthYear}</div>
                                </div>
                                <span class="badge">${author.books.size()} Book(s)</span>
                            </div>

                            <c:if test="${not empty author.notableAward}">
                                <div style="font-size:0.78rem; color:var(--gold); font-weight:600;">★ ${author.notableAward}</div>
                            </c:if>

                            <p style="font-size:0.86rem; color:var(--text-soft); flex:1;">${author.biography}</p>

                            <div style="display:flex; gap:8px; padding-top:0.75rem; border-top:1px solid var(--border);">
                                <a href="${pageContext.request.contextPath}/authors/${author.id}" class="btn btn-gold-outline btn-sm" style="flex:1;">Bibliography</a>
                                <a href="${pageContext.request.contextPath}/authors/edit/${author.id}" class="btn btn-secondary btn-sm">Edit</a>
                                <a href="${pageContext.request.contextPath}/authors/delete/${author.id}" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete author and all linked books?')">Delete</a>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
