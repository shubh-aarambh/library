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
                        <li><a href="${pageContext.request.contextPath}/authors" class="active">👤 Authors</a></li>
                        <li><a href="${pageContext.request.contextPath}/authors/new">➕ Add Author</a></li>
                        <li><a href="${pageContext.request.contextPath}/books">📖 Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/books/new">➕ Add Book</a></li>
                    </ul>
                </nav>

                <div class="container">
                    <div class="page-header">
                        <div>
                            <h1>${pageTitle}</h1>
                            <p class="page-subtitle">Fill in the details below</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary">← Back to
                            Authors</a>
                    </div>

                    <div class="card" style="max-width: 680px; margin: 0 auto;">
                        <form:form action="${pageContext.request.contextPath}${formAction}" method="post"
                            modelAttribute="author">

                            <div class="form-group">
                                <label for="name">Full Name *</label>
                                <form:input path="name" id="name" cssClass="form-control"
                                    placeholder="e.g. Ernest Hemingway" />
                                <form:errors path="name" cssClass="error-msg" />
                            </div>

                            <div class="form-group">
                                <label for="nationality">Nationality *</label>
                                <form:input path="nationality" id="nationality" cssClass="form-control"
                                    placeholder="e.g. American" />
                                <form:errors path="nationality" cssClass="error-msg" />
                            </div>

                            <div class="form-group">
                                <label for="birthYear">Birth Year *</label>
                                <form:input path="birthYear" id="birthYear" type="number" cssClass="form-control"
                                    placeholder="e.g. 1899" />
                                <form:errors path="birthYear" cssClass="error-msg" />
                            </div>

                            <div class="form-group">
                                <label for="biography">Biography</label>
                                <form:textarea path="biography" id="biography" cssClass="form-control" rows="3"
                                    placeholder="Brief description of the author..." />
                                <form:errors path="biography" cssClass="error-msg" />
                            </div>

                            <div style="display:flex; gap: 1rem; margin-top: 1.5rem;">
                                <button type="submit" class="btn btn-primary">💾 ${buttonLabel}</button>
                                <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary">✕
                                    Cancel</a>
                            </div>
                        </form:form>
                    </div>
                </div>

            </body>

            </html>