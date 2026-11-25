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
        <div style="margin-bottom:1.5rem; display:flex; justify-content:space-between; flex-wrap:wrap; gap:10px;">
            <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">← Back to Authors</a>
            <a href="${pageContext.request.contextPath}/authors/edit/${author.id}" class="btn btn-secondary btn-sm">Edit Author Profile</a>
        </div>

        <div class="card" style="padding:2rem; margin-bottom:2.25rem;">
            <div style="display:flex; gap:1.75rem; align-items:center; flex-wrap:wrap;">
                <div class="author-monogram" style="width:88px; height:88px; font-size:2rem; border-radius:20px; background:${author.avatarColor};">
                    ${author.initials}
                </div>
                <div style="flex:1; min-width:260px;">
                    <div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:0.5rem;">
                        <span class="badge">${author.nationality}</span>
                        <span class="badge badge-neutral">Born ${author.birthYear}</span>
                        <c:if test="${not empty author.notableAward}">
                            <span class="badge badge-violet">★ ${author.notableAward}</span>
                        </c:if>
                    </div>
                    <h1 class="serif" style="font-size:2.3rem; line-height:1.15; margin-bottom:0.65rem;">${author.name}</h1>
                    <p style="color:var(--text-soft); font-size:0.98rem; max-width:780px;">${author.biography}</p>
                </div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <div class="section-kicker">Published Works</div>
                <h2 class="section-title">Bibliography (${authorBooks.size()} Volume(s))</h2>
            </div>
            <a href="${pageContext.request.contextPath}/books/new" class="btn btn-primary btn-sm">+ Add Book</a>
        </div>

        <c:choose>
            <c:when test="${empty authorBooks}">
                <div class="card empty-state">
                    <h3>No Volumes Listed Yet</h3>
                    <p>Add a book linked to ${author.name} to populate this shelf.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="books-grid">
                    <c:forEach var="book" items="${authorBooks}">
                        <article class="book-card">
                            <a href="${pageContext.request.contextPath}/books/${book.id}" class="book-cover" style="background:${book.coverColor};">
                                <div class="book-cover-top">
                                    <span class="cover-genre">${book.genre}</span>
                                    <span class="cover-rating">★ ${book.rating}</span>
                                </div>
                                <div>
                                    <div class="book-cover-title">${book.title}</div>
                                    <div class="book-cover-author">${book.publishedYear} · ${book.pages} pages</div>
                                </div>
                            </a>
                            <div class="book-body">
                                <p class="book-desc">${book.description}</p>
                                <div class="book-meta-row">
                                    <span class="mono">Shelf ${book.shelfLocation}</span>
                                    <span class="badge ${book.available ? 'badge-emerald' : 'badge-danger'}">${book.availableCopies}/${book.totalCopies} Available</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/books/${book.id}" class="btn btn-primary btn-sm">Inspect &amp; Borrow</a>
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

