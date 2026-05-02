<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
                        <li><a href="${pageContext.request.contextPath}/authors">👤 Authors</a></li>
                        <li><a href="${pageContext.request.contextPath}/authors/new">➕ Add Author</a></li>
                        <li><a href="${pageContext.request.contextPath}/books" class="active">📖 Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/books/new">➕ Add Book</a></li>
                    </ul>
                </nav>

                <div class="container">
                    <div class="page-header">
                        <div>
                            <h1>${pageTitle}</h1>
                            <p class="page-subtitle">Fill in the book details below</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">← Back to Books</a>
                    </div>

                    <div class="card" style="max-width: 720px; margin: 0 auto;">
                        <form:form action="${pageContext.request.contextPath}${formAction}" method="post"
                            modelAttribute="book">

                            <div class="form-group">
                                <label for="title">Book Title *</label>
                                <form:input path="title" id="title" cssClass="form-control"
                                    placeholder="e.g. The Old Man and the Sea" />
                                <form:errors path="title" cssClass="error-msg" />
                            </div>

                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                                <div class="form-group">
                                    <label for="genre">Genre *</label>
                                    <form:input path="genre" id="genre" cssClass="form-control"
                                        placeholder="e.g. Fiction" />
                                    <form:errors path="genre" cssClass="error-msg" />
                                </div>

                                <div class="form-group">
                                    <label for="publishedYear">Published Year *</label>
                                    <form:input path="publishedYear" id="publishedYear" type="number"
                                        cssClass="form-control" placeholder="e.g. 1952" />
                                    <form:errors path="publishedYear" cssClass="error-msg" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="isbn">ISBN *</label>
                                <form:input path="isbn" id="isbn" cssClass="form-control"
                                    placeholder="e.g. ISBN-9780684801223" />
                                <form:errors path="isbn" cssClass="error-msg" />
                            </div>

                            <div class="form-group">
                                <label for="author.id">Author *</label>
                                <form:select path="author.id" id="author.id" cssClass="form-control">
                                    <form:option value="" label="— Select an Author —" />
                                    <c:forEach var="a" items="${authors}">
                                        <form:option value="${a.id}" label="${a.name} (${a.nationality})" />
                                    </c:forEach>
                                </form:select>
                                <form:errors path="author" cssClass="error-msg" />
                            </div>

                            <div class="form-group">
                                <label for="description">Description</label>
                                <form:textarea path="description" id="description" cssClass="form-control" rows="3"
                                    placeholder="Short summary of the book..." />
                            </div>

                            <div style="display:flex; gap: 1rem; margin-top: 1.5rem;">
                                <button type="submit" class="btn btn-primary">💾 ${buttonLabel}</button>
                                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">✕
                                    Cancel</a>
                            </div>
                        </form:form>
                    </div>
                </div>

            </body>

            </html>