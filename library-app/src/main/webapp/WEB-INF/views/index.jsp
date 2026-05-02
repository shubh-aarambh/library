<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
        <span class="brand-icon">📚</span>
        <span>Library Manager</span>
    </a>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/authors">👤 Authors</a></li>
        <li><a href="${pageContext.request.contextPath}/authors/new">➕ Add Author</a></li>
        <li><a href="${pageContext.request.contextPath}/books">📖 Books</a></li>
        <li><a href="${pageContext.request.contextPath}/books/new">➕ Add Book</a></li>
        <li><a href="${pageContext.request.contextPath}/books/joined">🔗 Joined View</a></li>
        <li><a href="${pageContext.request.contextPath}/h2-console" target="_blank">🗄️ DB Console</a></li>
    </ul>
</nav>

<div class="hero">
    <h1>📚 Library Manager</h1>
    <p>A Spring Boot application to manage your collection of Books and Authors with full CRUD operations.</p>

    <div class="hero-cards">
        <a href="${pageContext.request.contextPath}/authors" class="hero-card">
            <div class="hero-card-icon">👤</div>
            <h3>Authors</h3>
            <p>Browse, add, and edit author profiles including nationality and biography.</p>
        </a>
        <a href="${pageContext.request.contextPath}/books" class="hero-card">
            <div class="hero-card-icon">📖</div>
            <h3>Books</h3>
            <p>Manage the book catalogue with genre, ISBN, publication year, and author links.</p>
        </a>
        <a href="${pageContext.request.contextPath}/books/joined" class="hero-card">
            <div class="hero-card-icon">🔗</div>
            <h3>Joined View</h3>
            <p>See an INNER JOIN result showing each book alongside its author's details.</p>
        </a>
    </div>
</div>

</body>
</html>
