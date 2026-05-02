<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error ${errorCode} — Library Manager</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
        </head>

        <body>

            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <span class="brand-icon">📚</span>
                    <span>Library Manager</span>
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/">🏠 Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/authors">👤 Authors</a></li>
                    <li><a href="${pageContext.request.contextPath}/books">📖 Books</a></li>
                </ul>
            </nav>

            <div class="container" style="display:flex; align-items:center; justify-content:center; min-height:70vh;">
                <div class="card" style="max-width:600px; width:100%; text-align:center;">
                    <div style="font-size:4rem; margin-bottom:1rem;">
                        <c:choose>
                            <c:when test="${errorCode == '404'}">🔍</c:when>
                            <c:when test="${errorCode == '409'}">⚠️</c:when>
                            <c:otherwise>💥</c:otherwise>
                        </c:choose>
                    </div>

                    <h1
                        style="font-family:'Playfair Display',serif; color:var(--danger); font-size:1.8rem; margin-bottom:0.5rem;">
                        ${errorCode} — ${errorTitle}
                    </h1>

                    <p style="color:var(--muted); margin-bottom:2rem; line-height:1.7;">
                        ${errorMessage}
                    </p>

                    <div style="display:flex; gap:1rem; justify-content:center;">
                        <a href="javascript:history.back()" class="btn btn-secondary">← Go Back</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 Go Home</a>
                    </div>
                </div>
            </div>

        </body>

        </html>