<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign In — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="auth-wrap">
        <div class="panel">
            <h1 class="serif" style="font-size:1.85rem; margin-bottom:0.25rem;">Sign in to Athenaeum</h1>
            <p style="font-size:0.88rem; color:var(--ink-2); margin-bottom:1.35rem;">Borrow books, join waitlists, and track your reading shelf.</p>

            <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
            <c:if test="${not empty infoMessage}"><div class="alert alert-info">${infoMessage}</div></c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="next" value="${nextUrl}">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="reader@library.dev">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Sign in</button>
            </form>

            <div class="demo-callout">
                <div style="font-weight:600; margin-bottom:4px;">Demo Member Account</div>
                <div style="color:var(--ink-2); margin-bottom:10px;"><span class="mono">reader@library.dev</span> / <span class="mono">reader123</span></div>
                <form action="${pageContext.request.contextPath}/demo-login" method="post">
                    <input type="hidden" name="next" value="${nextUrl}">
                    <button type="submit" class="btn btn-secondary btn-sm btn-block">Sign in as Demo Member</button>
                </form>
            </div>

            <div style="margin-top:1.25rem; font-size:0.84rem; color:var(--ink-2); text-align:center;">
                Need a library card? <a href="${pageContext.request.contextPath}/register" style="color:var(--accent); font-weight:600;">Register</a>
                · <a href="${pageContext.request.contextPath}/admin/login" class="header-link">Staff sign in</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
