<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
        <span class="brand-mark">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
        </span>
        <span>
            <span class="brand-title">Athenaeum</span>
            <span class="brand-sub">Smart Library</span>
        </span>
    </a>

    <ul class="navbar-links" id="navbarLinks">
        <li><a href="${pageContext.request.contextPath}/" class="${currentPath == '/' ? 'active' : ''}">Discover</a></li>
        <li><a href="${pageContext.request.contextPath}/books" class="${currentPath == '/books' || (currentPath.startsWith('/books/') && currentPath != '/books/joined') ? 'active' : ''}">Catalog</a></li>
        <li><a href="${pageContext.request.contextPath}/authors" class="${currentPath.startsWith('/authors') ? 'active' : ''}">Authors</a></li>
        <li><a href="${pageContext.request.contextPath}/my-library" class="${currentPath.startsWith('/my-library') ? 'active' : ''}">My Library</a></li>
    </ul>

    <div class="navbar-actions">
        <button type="button" class="nav-search-trigger" onclick="openSpotlight()">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <span>Search books, authors...</span>
            <span class="kbd-pill">⌘K</span>
        </button>

        <button type="button" class="icon-btn" onclick="toggleTheme()" title="Switch Light / Dark Mode" aria-label="Switch Theme">
            <span data-theme-icon>☾</span>
        </button>

        <c:choose>
            <c:when test="${not empty currentUser}">
                <c:if test="${currentUser.admin}">
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-dark btn-sm">Librarian Admin</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/my-library" class="user-pill" title="${currentUser.email}">
                    <span class="user-avatar">${currentUser.initials}</span>
                    <span>${currentUser.fullName}</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary btn-sm">Sign Out</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-secondary btn-sm">Librarian Portal</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Sign In</a>
            </c:otherwise>
        </c:choose>

        <button type="button" class="icon-btn mobile-menu-btn" id="mobileNavToggle" aria-label="Menu">☰</button>
    </div>
</nav>

<!-- Global Cmd+K Spotlight Search Modal -->
<div class="modal-backdrop" id="spotlightModal" onclick="if(event.target===this) closeSpotlight()">
    <div class="cmd-modal">
        <div class="cmd-input-row">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="color:var(--accent);">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <input type="text" id="spotlightInput" placeholder="Type a book title, author, genre, or ISBN...">
            <button type="button" class="btn btn-secondary btn-sm" onclick="closeSpotlight()">ESC</button>
        </div>
        <div class="cmd-results" id="spotlightResults"></div>
    </div>
</div>

<!-- Global Built-in Reader Preview & Study Guide Modal -->
<div class="modal-backdrop" id="readerModalBackdrop" onclick="if(event.target===this) closeReaderPreview()">
    <div class="reader-modal" id="readerSheet" data-reader-theme="paper">
        <div class="reader-toolbar">
            <div>
                <div style="font-size:0.7rem; font-weight:800; text-transform:uppercase; letter-spacing:0.1em; opacity:0.65;">Athenaeum E-Reader · Preview &amp; Study Guide</div>
                <strong id="readerTitle" class="serif" style="font-size:1.55rem; line-height:1.15;"></strong>
                <div id="readerMeta" style="font-size:0.78rem; opacity:0.72;"></div>
            </div>
            <div style="display:flex; align-items:center; gap:6px;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="adjustReaderFont(-0.08)">A-</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="adjustReaderFont(0.08)">A+</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('paper')">Paper</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('sepia')">Sepia</button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="setReaderTheme('night')">Night</button>
                <button type="button" class="btn btn-danger btn-sm" onclick="closeReaderPreview()">✕</button>
            </div>
        </div>
        <div style="padding:0.85rem 2.25rem; background:rgba(194,94,40,0.09); font-size:0.85rem; font-weight:600;" id="readerNote"></div>
        <div class="reader-body" id="readerContent"></div>
        <div class="reader-footer">
            <span style="font-size:0.8rem; opacity:0.7;">Original curated Athenaeum reader orientation &amp; discussion notes</span>
            <a id="readerBookLink" href="#" class="btn btn-primary btn-sm">View Full Book &amp; Borrow →</a>
        </div>
    </div>
</div>
