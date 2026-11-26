<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Authors — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="page-top">
            <div>
                <h1 class="page-title">${pageTitle}</h1>
                <p class="page-sub">${authors.size()} author(s) represented in the catalog</p>
            </div>
            <div style="display:flex; gap:8px;">
                <c:choose>
                    <c:when test="${joinedView}">
                        <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">All authors</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/authors/with-books" class="btn btn-secondary btn-sm">Only with books</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}${joinedView ? '/authors/with-books' : '/authors'}" method="get" class="filter-strip">
            <input type="text" name="q" value="${query}" class="input" style="flex:1 1 240px;" placeholder="Search authors by name, nationality, or award...">
            <select name="nationality" class="select" onchange="this.form.submit()">
                <option value="ALL" ${selectedNationality == 'ALL' ? 'selected' : ''}>All nationalities</option>
                <c:forEach var="nat" items="${nationalities}">
                    <option value="${nat}" ${selectedNationality == nat ? 'selected' : ''}>${nat}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
        </form>

        <div class="author-list-grid">
            <c:forEach var="author" items="${authors}">
                <a href="${pageContext.request.contextPath}/authors/${author.id}" class="author-tile">
                    <div class="author-head">
                        <div class="author-circle" style="background:${author.avatarColor};">${author.initials}</div>
                        <div style="flex:1; min-width:0;">
                            <div style="font-weight:600; font-size:0.98rem;">${author.name}</div>
                            <div style="font-size:0.8rem; color:var(--ink-3);">${author.nationality} · b. ${author.birthYear}</div>
                        </div>
                        <span class="tag">${author.books.size()}</span>
                    </div>
                    <p style="font-size:0.86rem; color:var(--ink-2); flex:1;">${author.biography}</p>
                    <c:if test="${not empty author.notableAward}">
                        <div style="font-size:0.78rem; color:var(--accent); font-weight:500;">${author.notableAward}</div>
                    </c:if>
                </a>
            </c:forEach>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
