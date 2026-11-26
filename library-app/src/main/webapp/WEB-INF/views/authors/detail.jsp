<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${author.name} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div style="font-size:0.83rem; color:var(--ink-3); margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/authors" class="header-link">Authors</a> / <span>${author.name}</span>
        </div>

        <div style="display:flex; gap:1.5rem; align-items:flex-start; flex-wrap:wrap; padding-bottom:2rem; margin-bottom:2rem; border-bottom:1px solid var(--border);">
            <div class="author-circle" style="width:74px; height:74px; font-size:1.7rem; background:${author.avatarColor};">${author.initials}</div>
            <div style="flex:1; min-width:260px;">
                <h1 class="serif" style="font-size:2.3rem; line-height:1.12; margin-bottom:0.3rem;">${author.name}</h1>
                <div style="font-size:0.88rem; color:var(--ink-2); margin-bottom:0.75rem;">
                    ${author.nationality} · Born ${author.birthYear}
                    <c:if test="${not empty author.notableAward}"> · <span style="color:var(--accent); font-weight:600;">${author.notableAward}</span></c:if>
                </div>
                <p style="font-size:0.95rem; color:var(--ink-2); max-width:720px; line-height:1.68;">${author.biography}</p>
            </div>
        </div>

        <div class="section-head">
            <h2>Works in Library (${authorBooks.size()})</h2>
        </div>

        <div class="shelf-grid">
            <c:forEach var="book" items="${authorBooks}">
                <article class="book-item">
                    <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-cover-frame" style="background:${book.coverColor};">
                        <c:if test="${not empty book.resolvedCoverUrl}">
                            <img class="book-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" loading="lazy" onerror="this.style.display='none'">
                        </c:if>
                        <div class="book-cover-fallback">
                            <span class="book-cover-fallback-genre">${book.genre}</span>
                            <div>
                                <div class="book-cover-fallback-title">${book.title}</div>
                                <div class="book-cover-fallback-author">${book.publishedYear}</div>
                            </div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-item-title">${book.title}</a>
                    <div class="book-item-author">${book.publishedYear} · Shelf ${book.shelfLocation}</div>
                    <div class="book-item-status">
                        <span class="status-dot ${book.available ? 'avail' : 'wait'}">${book.available ? 'Available' : 'Waitlist'}</span>
                        <span class="mono">${book.rating} ★</span>
                    </div>
                </article>
            </c:forEach>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
