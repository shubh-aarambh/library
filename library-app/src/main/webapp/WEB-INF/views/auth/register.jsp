<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register Library Card — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="auth-wrap">
        <div class="panel">
            <h1 class="serif" style="font-size:1.85rem; margin-bottom:0.25rem;">Get a Library Card</h1>
            <p style="font-size:0.88rem; color:var(--ink-2); margin-bottom:1.35rem;">Free membership for campus &amp; digital borrowing.</p>

            <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="fullName">Full name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="password">Password (min 6 characters)</label>
                    <input type="password" id="password" name="password" class="form-control" minlength="6" required>
                </div>
                <div class="form-group">
                    <label for="tier">Membership tier</label>
                    <select id="tier" name="tier" class="form-control">
                        <option value="STANDARD">Standard (3 active loans)</option>
                        <option value="SCHOLAR">Scholar (6 active loans)</option>
                        <option value="VIP">VIP Patron (10 active loans)</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Create library card</button>
            </form>

            <div style="margin-top:1.25rem; font-size:0.84rem; color:var(--ink-2); text-align:center;">
                Already a member? <a href="${pageContext.request.contextPath}/login" style="color:var(--accent); font-weight:600;">Sign in</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
