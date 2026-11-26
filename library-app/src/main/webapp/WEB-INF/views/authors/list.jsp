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
                <div class="section-kicker">Literary Archive</div>
                <h1 class="section-title">${pageTitle}</h1>
                <p class="section-subtitle">${authors.size()} author profile(s) with curated biographies and bibliographies</p>
            </div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
                <c:choose>
                    <c:when test="${joinedView}">
                        <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">Show All Authors</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/authors/with-books" class="btn btn-secondary btn-sm">Authors With Books</a>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty currentUser && currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/admin/authors" class="btn btn-dark btn-sm">Manage in Admin →</a>
                </c:if>
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
                <input type="text" name="q" value="${query}" placeholder="Search authors by name, nationality, or award...">
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
                    <p>Try resetting your search filters.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="authors-grid">
                    <c:forEach var="author" items="${authors}">
                        <a href="${pageContext.request.contextPath}/authors/${author.id}" class="author-card">
                            <div class="author-header">
                                <div class="author-monogram" style="background:${author.avatarColor};">${author.initials}</div>
                                <div style="flex:1; min-width:0;">
                                    <div style="font-size:1.1rem; font-weight:700;">${author.name}</div>
                                    <div style="font-size:0.8rem; color:var(--text-muted);">${author.nationality} · b. ${author.birthYear}</div>
                                </div>
                                <span class="badge badge-neutral">${author.books.size()} Title(s)</span>
                            </div>

                            <c:if test="${not empty author.notableAward}">
                                <div style="font-size:0.78rem; color:var(--accent); font-weight:700;">★ ${author.notableAward}</div>
                            </c:if>

                            <p style="font-size:0.87rem; color:var(--text-soft); flex:1;">${author.biography}</p>

                            <div style="padding-top:0.7rem; border-top:1px solid var(--border); font-size:0.82rem; font-weight:700; color:var(--accent);">
                                View Bibliography →
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
