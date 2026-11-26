<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Error ${errorCode} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="auth-wrap" style="max-width:520px; text-align:center;">
        <div class="panel">
            <div class="tag tag-red" style="margin-bottom:0.85rem;">HTTP ${errorCode}</div>
            <h1 class="serif" style="font-size:1.85rem; margin-bottom:0.5rem;">${errorTitle}</h1>
            <p style="font-size:0.9rem; color:var(--ink-2); margin-bottom:1.5rem;">${errorMessage}</p>
            <div style="display:flex; gap:8px; justify-content:center;">
                <a href="javascript:history.back()" class="btn btn-secondary">Go back</a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return home</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
