<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Staff Admin Sign In — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="auth-wrap">
        <div class="panel">
            <div style="font-size:0.74rem; font-weight:600; text-transform:uppercase; letter-spacing:0.06em; color:var(--accent); margin-bottom:4px;">Staff Portal</div>
            <h1 class="serif" style="font-size:1.85rem; margin-bottom:0.25rem;">Librarian Sign In</h1>
            <p style="font-size:0.88rem; color:var(--ink-2); margin-bottom:1.25rem;">Manage catalog stock, loans, waitlist holds, fines, and members.</p>

            <c:if test="${authRequired}"><div class="alert alert-info">Please sign in with an administrator account.</div></c:if>
            <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

            <form action="${pageContext.request.contextPath}/admin/login" method="post">
                <div class="form-group">
                    <label for="email">Staff email</label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="admin@library.dev">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-dark btn-block">Sign in to Admin</button>
            </form>

            <div class="demo-callout">
                <div style="font-weight:600; margin-bottom:4px;">Demo Librarian Credentials</div>
                <div style="color:var(--ink-2); margin-bottom:10px;"><span class="mono">admin@library.dev</span> / <span class="mono">admin123</span></div>
                <form action="${pageContext.request.contextPath}/admin/demo-login" method="post">
                    <button type="submit" class="btn btn-primary btn-sm btn-block">Sign in as Demo Librarian</button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
