<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="site-header">
    <div class="header-inner">
        <a href="${pageContext.request.contextPath}/" class="wordmark">Athenaeum</a>

        <form action="${pageContext.request.contextPath}/books" method="get" class="header-search" autocomplete="off">
            <svg class="header-search-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <input type="text" id="headerSearchInput" name="q" class="header-search-input"
                   placeholder="Search title, author, or ISBN..." value="${query}">
            <div class="search-dropdown" id="headerSearchDropdown" hidden></div>
        </form>

        <ul class="main-nav" id="mainNav">
            <li><a href="${pageContext.request.contextPath}/" class="${currentPath == '/' ? 'active' : ''}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/books" class="${currentPath == '/books' || (currentPath.startsWith('/books/') && currentPath != '/books/joined') ? 'active' : ''}">Books</a></li>
            <li><a href="${pageContext.request.contextPath}/authors" class="${currentPath.startsWith('/authors') ? 'active' : ''}">Authors</a></li>
            <li><a href="${pageContext.request.contextPath}/my-library" class="${currentPath.startsWith('/my-library') ? 'active' : ''}">My Shelf</a></li>
        </ul>

        <div class="header-right">
            <button type="button" class="theme-btn" onclick="toggleTheme()" title="Toggle light/dark mode" aria-label="Toggle theme">
                <span data-theme-icon>☾</span>
            </button>

            <c:choose>
                <c:when test="${not empty currentUser}">
                    <c:if test="${currentUser.admin}">
                        <a href="${pageContext.request.contextPath}/admin" class="header-link">Staff Admin</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/my-library" class="btn btn-secondary btn-sm">${currentUser.fullName}</a>
                    <a href="${pageContext.request.contextPath}/logout" class="header-link">Sign out</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/login" class="header-link">Staff</a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Sign in</a>
                </c:otherwise>
            </c:choose>

            <button type="button" class="theme-btn mobile-menu-btn" id="mobileNavToggle" aria-label="Menu">☰</button>
        </div>
    </div>
</header>

<!-- Reader Study Guide Modal (Native hidden attribute guarantees zero flash/leak) -->
<div class="modal-backdrop" id="readerModalBackdrop" hidden onclick="if(event.target===this) closeReaderPreview()">
    <div class="reader-dialog" id="readerSheet" data-reader-theme="paper">
        <div class="reader-head">
            <div>
                <div id="readerTitle" class="serif" style="font-size:1.35rem; font-weight:600; line-height:1.2;"></div>
                <div id="readerMeta" style="font-size:0.78rem; opacity:0.72;"></div>
            </div>
            <div style="display:flex; align-items:center; gap:5px;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="adjustReaderFont(-0.08)">A-</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="adjustReaderFont(0.08)">A+</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('paper')">Paper</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('sepia')">Sepia</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('night')">Night</button>
                <button type="button" class="btn btn-ghost btn-sm" onclick="closeReaderPreview()" aria-label="Close">✕</button>
            </div>
        </div>
        <div class="reader-body" id="readerContent"></div>
        <div class="reader-foot">
            <span style="font-size:0.78rem; opacity:0.7;">Athenaeum reading notes &amp; discussion guide</span>
            <a id="readerBookLink" href="#" class="btn btn-primary btn-sm">View book</a>
        </div>
    </div>
</div>
