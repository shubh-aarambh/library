<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
                <div class="section-kicker">Author Registry</div>
                <h1 class="section-title">${pageTitle}</h1>
                <p class="section-subtitle">Add or update biographical details and literary honors</p>
            </div>
            <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary btn-sm">← Back to Authors</a>
        </div>

        <div class="card" style="max-width:720px; margin:0 auto;">
            <form:form action="${pageContext.request.contextPath}${formAction}" method="post" modelAttribute="author">
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <form:input path="name" id="name" cssClass="form-control" placeholder="e.g. Ernest Hemingway"/>
                    <form:errors path="name" cssClass="error-msg"/>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="nationality">Nationality *</label>
                        <form:input path="nationality" id="nationality" cssClass="form-control" placeholder="e.g. American"/>
                        <form:errors path="nationality" cssClass="error-msg"/>
                    </div>
                    <div class="form-group">
                        <label for="birthYear">Birth Year *</label>
                        <form:input path="birthYear" id="birthYear" type="number" cssClass="form-control" placeholder="e.g. 1899"/>
                        <form:errors path="birthYear" cssClass="error-msg"/>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="notableAward">Notable Award / Distinction</label>
                        <form:input path="notableAward" id="notableAward" cssClass="form-control" placeholder="e.g. Nobel Prize in Literature"/>
                    </div>
                    <div class="form-group">
                        <label for="avatarColor">Monogram Accent Color</label>
                        <form:select path="avatarColor" id="avatarColor" cssClass="form-control">
                            <form:option value="#d97706" label="Amber Gold"/>
                            <form:option value="#0284c7" label="Sapphire Blue"/>
                            <form:option value="#059669" label="Emerald Green"/>
                            <form:option value="#7c3aed" label="Royal Violet"/>
                            <form:option value="#dc2626" label="Crimson Red"/>
                            <form:option value="#db2777" label="Rose Pink"/>
                            <form:option value="#0d9488" label="Teal"/>
                        </form:select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="biography">Biography</label>
                    <form:textarea path="biography" id="biography" cssClass="form-control" rows="4"
                                   placeholder="Brief literary biography of the author..."/>
                    <form:errors path="biography" cssClass="error-msg"/>
                </div>

                <div style="display:flex; gap:12px; margin-top:1.5rem;">
                    <button type="submit" class="btn btn-primary">${buttonLabel}</button>
                    <a href="${pageContext.request.contextPath}/authors" class="btn btn-secondary">Cancel</a>
                </div>
            </form:form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
