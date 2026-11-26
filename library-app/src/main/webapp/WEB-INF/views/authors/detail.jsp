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
        <div style="margin-bottom:1.4rem; display:flex; justify-content:space-between; flex-wrap:wrap; gap:10px;">
            <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">← Back to Authors</a>
            <c:if test="${not empty currentUser && currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/authors/edit/${author.id}" class="btn btn-dark btn-sm">Edit in Admin</a>
            </c:if>
        </div>

        <div class="card" style="padding:2rem; margin-bottom:2.25rem;">
            <div style="display:flex; gap:1.75rem; align-items:center; flex-wrap:wrap;">
                <div class="author-monogram" style="width:92px; height:92px; font-size:2.3rem; background:${author.avatarColor};">
                    ${author.initials}
                </div>
                <div style="flex:1; min-width:260px;">
                    <div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:0.5rem;">
                        <span class="badge badge-neutral">${author.nationality}</span>
                        <span class="badge badge-neutral">Born ${author.birthYear}</span>
                        <c:if test="${not empty author.notableAward}">
                            <span class="badge">★ ${author.notableAward}</span>
                        </c:if>
                    </div>
                    <h1 class="serif" style="font-size:2.7rem; line-height:1.1; margin-bottom:0.65rem;">${author.name}</h1>
                    <p style="color:var(--text-soft); font-size:0.98rem; max-width:780px;">${author.biography}</p>
                </div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <div class="section-kicker">Published Works in Archive</div>
                <h2 class="section-title">Bibliography (${authorBooks.size()})</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty authorBooks}">
                <div class="card empty-state">
                    <h3>No Volumes Listed Yet</h3>
                    <p>No books are currently linked to ${author.name}.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="books-grid">
                    <c:forEach var="book" items="${authorBooks}">
                        <article class="book-tile">
                            <div class="book-tile-cover-wrap">
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="real-cover" style="background:${book.coverColor};">
                                    <c:if test="${not empty book.resolvedCoverUrl}">
                                        <img class="real-cover-img" src="${book.resolvedCoverUrl}" alt="${book.title}" loading="lazy" onerror="this.style.display='none'">
                                    </c:if>
                                    <span class="cover-ribbon ${book.available ? 'avail' : 'waitlist'}">
                                        ${book.available ? book.availableCopies : 'Waitlist'}${book.available ? ' avail' : ''}
                                    </span>
                                    <div class="cover-fallback">
                                        <span style="font-size:0.7rem; text-transform:uppercase; letter-spacing:0.1em; opacity:0.8;">${book.genre}</span>
                                        <div>
                                            <div class="cover-fallback-title">${book.title}</div>
                                            <div class="cover-fallback-author">${book.publishedYear}</div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="book-tile-meta">
                                <span>${book.genre} · ${book.formattedReadingTime}</span>
                                <span style="color:var(--accent);">★ ${book.rating}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-tile-title">${book.title}</a>
                            <div class="book-tile-author">Shelf ${book.shelfLocation} · ${book.publishedYear}</div>
                            <div class="book-tile-footer">
                                <button type="button" class="btn btn-secondary btn-sm" onclick="openReaderPreview(${book.id})">Preview</button>
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary btn-sm" style="flex:1;">
                                    ${book.available ? 'Borrow' : 'Waitlist'}
                                </a>
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
