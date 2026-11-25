<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Library Card — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content auth-shell">
    <div class="auth-card">
        <div class="section-kicker">Membership</div>
        <h1 class="serif" style="font-size:1.95rem; margin-bottom:0.35rem;">Create Your Library Card</h1>
        <p style="color:var(--text-soft); font-size:0.9rem; margin-bottom:1.5rem;">Instant access to borrowing, renewals, reading lists, and community reviews.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="e.g. Ananya Sharma">
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" required placeholder="you@example.com">
            </div>
            <div class="form-group">
                <label for="password">Password (min 6 chars)</label>
                <input type="password" id="password" name="password" class="form-control" minlength="6" required placeholder="Create a secure password">
            </div>
            <div class="form-group">
                <label for="tier">Membership Tier</label>
                <select id="tier" name="tier" class="form-control">
                    <option value="STANDARD">Standard Reader (Up to 3 active loans)</option>
                    <option value="SCHOLAR">Scholar Pass (Up to 6 active loans)</option>
                    <option value="VIP">VIP Patron (Up to 10 active loans)</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">Activate Library Card</button>
        </form>

        <div style="margin-top:1.35rem; text-align:center; font-size:0.86rem; color:var(--text-soft);">
            Already have a card? <a href="${pageContext.request.contextPath}/login" style="color:var(--gold); font-weight:700;">Sign In</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>

