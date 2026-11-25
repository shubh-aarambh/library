<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Member Sign In — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content auth-shell">
    <div class="auth-card">
        <div class="section-kicker">Reader Portal</div>
        <h1 class="serif" style="font-size:1.95rem; margin-bottom:0.35rem;">Welcome Back</h1>
        <p style="color:var(--text-soft); font-size:0.9rem; margin-bottom:1.5rem;">Sign in to borrow books, manage loans, and curate your reading list.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty infoMessage}">
            <div class="alert alert-info">${infoMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="next" value="${nextUrl}">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" required placeholder="reader@library.dev">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">Sign In</button>
        </form>

        <div class="demo-box">
            <div style="font-weight:700; color:var(--gold); margin-bottom:4px;">Instant Portfolio Demo Access</div>
            <div style="color:var(--text-soft); margin-bottom:10px;">
                Reader: <code class="mono">reader@library.dev</code> / <code class="mono">reader123</code>
            </div>
            <form action="${pageContext.request.contextPath}/demo-login" method="post">
                <input type="hidden" name="next" value="${nextUrl}">
                <button type="submit" class="btn btn-gold-outline btn-sm btn-block">1-Click Sign In as Demo Reader</button>
            </form>
        </div>

        <div style="margin-top:1.35rem; text-align:center; font-size:0.86rem; color:var(--text-soft);">
            New to Athenaeum? <a href="${pageContext.request.contextPath}/register" style="color:var(--gold); font-weight:700;">Create a Library Card</a>
            <div style="margin-top:8px;">
                Staff or Librarian? <a href="${pageContext.request.contextPath}/admin/login" style="color:var(--sky); font-weight:600;">Go to Admin Login →</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>

