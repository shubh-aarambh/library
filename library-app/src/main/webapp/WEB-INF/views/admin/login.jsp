<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Console Sign In — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content auth-shell">
    <div class="auth-card" style="border-color:var(--border-strong);">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:0.75rem;">
            <span class="badge">RBAC PROTECTED</span>
            <span class="mono" style="font-size:0.74rem; color:var(--text-muted);">/admin</span>
        </div>
        <h1 class="serif" style="font-size:2rem; margin-bottom:0.35rem;">Admin Control Plane</h1>
        <p style="color:var(--text-soft); font-size:0.9rem; margin-bottom:1.4rem;">
            Sign in with an administrator account to manage inventory, circulation loans, fines, members, and audit logs.
        </p>

        <c:if test="${authRequired}">
            <div class="alert alert-info">Administrator authentication is required to access the Admin Console.</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <div class="form-group">
                <label for="email">Admin Email</label>
                <input type="email" id="email" name="email" class="form-control" required placeholder="admin@library.dev">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">Enter Admin Console</button>
        </form>

        <div class="demo-box">
            <div style="font-weight:700; color:var(--gold); margin-bottom:4px;">Portfolio Reviewer Demo Admin</div>
            <div style="color:var(--text-soft); margin-bottom:10px;">
                Email: <code class="mono">admin@library.dev</code> · Password: <code class="mono">admin123</code>
            </div>
            <form action="${pageContext.request.contextPath}/admin/demo-login" method="post">
                <button type="submit" class="btn btn-gold-outline btn-sm btn-block">1-Click Launch Demo Admin Console</button>
            </form>
        </div>

        <div style="margin-top:1.25rem; text-align:center; font-size:0.84rem; color:var(--text-muted);">
            <a href="${pageContext.request.contextPath}/" style="color:var(--text-soft);">← Back to Public Library</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>

