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

<main class="main-content auth-shell">
    <div class="auth-card" style="text-align:center; max-width:560px;">
        <div class="badge badge-danger" style="margin-bottom:1rem;">HTTP ${errorCode}</div>
        <h1 class="serif" style="font-size:2rem; margin-bottom:0.75rem;">${errorTitle}</h1>
        <p style="color:var(--text-soft); margin-bottom:1.75rem; font-size:0.94rem;">${errorMessage}</p>
        <div style="display:flex; gap:10px; justify-content:center; flex-wrap:wrap;">
            <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return Home</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
