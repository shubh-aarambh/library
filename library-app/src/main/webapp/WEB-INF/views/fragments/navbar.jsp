<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
        <span class="brand-mark">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
        </span>
        <span>
            Athenaeum
            <small>Digital Library</small>
        </span>
    </a>

    <ul class="navbar-links" id="navbarLinks">
        <li><a href="${pageContext.request.contextPath}/" class="${currentPath == '/' ? 'active' : ''}">Discover</a></li>
        <li><a href="${pageContext.request.contextPath}/books" class="${currentPath == '/books' || (currentPath.startsWith('/books/') && currentPath != '/books/joined') ? 'active' : ''}">Catalog</a></li>
        <li><a href="${pageContext.request.contextPath}/authors" class="${currentPath.startsWith('/authors') ? 'active' : ''}">Authors</a></li>
        <li><a href="${pageContext.request.contextPath}/books/joined" class="${currentPath == '/books/joined' ? 'active' : ''}">JPQL Explorer</a></li>
        <c:if test="${not empty currentUser}">
            <li><a href="${pageContext.request.contextPath}/my-library" class="${currentPath.startsWith('/my-library') ? 'active' : ''}">My Library</a></li>
        </c:if>
    </ul>

    <div class="navbar-actions">
        <button type="button" class="icon-btn" onclick="toggleTheme()" title="Toggle Dark / Light Theme" aria-label="Toggle Theme">
            <span data-theme-icon>☀</span>
        </button>

        <c:choose>
            <c:when test="${not empty currentUser}">
                <c:if test="${currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-gold-outline btn-sm">Admin Console</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/my-library" class="user-pill" title="${currentUser.email}">
                    <span class="user-avatar">${currentUser.initials}</span>
                    <span>${currentUser.fullName}</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm">Sign Out</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-secondary btn-sm">Admin</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Sign In</a>
            </c:otherwise>
        </c:choose>

        <button type="button" class="icon-btn mobile-menu-btn" id="mobileNavToggle" aria-label="Menu">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <line x1="3" y1="12" x2="21" y2="12"></line>
                <line x1="3" y1="18" x2="21" y2="18"></line>
            </svg>
        </button>
    </div>
</nav>

