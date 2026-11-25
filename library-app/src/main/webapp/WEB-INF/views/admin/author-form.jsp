<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} — Admin Console</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="section-header">
    <div>
        <h1 class="section-title" style="font-size:1.75rem;">${pageTitle}</h1>
        <p class="section-subtitle">Maintain canonical author profiles in the registry</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/authors" class="btn btn-secondary btn-sm">← Back to Authors</a>
</div>

<div class="card" style="max-width:740px;">
    <form:form action="${pageContext.request.contextPath}${formAction}" method="post" modelAttribute="author">
        <div class="form-group">
            <label for="name">Full Name *</label>
            <form:input path="name" id="name" cssClass="form-control" placeholder="e.g. Ursula K. Le Guin"/>
            <form:errors path="name" cssClass="error-msg"/>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label for="nationality">Nationality *</label>
                <form:input path="nationality" id="nationality" cssClass="form-control" placeholder="American"/>
                <form:errors path="nationality" cssClass="error-msg"/>
            </div>
            <div class="form-group">
                <label for="birthYear">Birth Year *</label>
                <form:input path="birthYear" id="birthYear" type="number" cssClass="form-control" placeholder="1929"/>
                <form:errors path="birthYear" cssClass="error-msg"/>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label for="notableAward">Notable Award</label>
                <form:input path="notableAward" id="notableAward" cssClass="form-control" placeholder="National Book Award"/>
            </div>
            <div class="form-group">
                <label for="avatarColor">Monogram Accent Color</label>
                <form:select path="avatarColor" id="avatarColor" cssClass="form-control">
                    <form:option value="#d97706" label="Amber Gold"/>
                    <form:option value="#0284c7" label="Sapphire Blue"/>
                    <form:option value="#059669" label="Emerald Green"/>
                    <form:option value="#7c3aed" label="Royal Violet"/>
                    <form:option value="#dc2626" label="Crimson Red"/>
                    <form:option value="#0d9488" label="Teal"/>
                </form:select>
            </div>
        </div>

        <div class="form-group">
            <label for="biography">Biography</label>
            <form:textarea path="biography" id="biography" cssClass="form-control" rows="4"/>
            <form:errors path="biography" cssClass="error-msg"/>
        </div>

        <div style="display:flex; gap:12px; margin-top:1.5rem;">
            <button type="submit" class="btn btn-primary">${buttonLabel}</button>
            <a href="${pageContext.request.contextPath}/admin/authors" class="btn btn-secondary">Cancel</a>
        </div>
    </form:form>
</div>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>

