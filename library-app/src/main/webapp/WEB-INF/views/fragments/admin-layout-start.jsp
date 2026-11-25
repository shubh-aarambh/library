<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="admin-shell">
    <aside class="admin-sidebar" id="adminSidebar">
        <a href="${pageContext.request.contextPath}/admin" class="admin-brand">
            <span class="brand-mark">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                    <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
                    <path d="M2 17l10 5 10-5"></path>
                    <path d="M2 12l10 5 10-5"></path>
                </svg>
            </span>
            <div>
                <div class="serif" style="font-size:1.15rem; font-weight:700;">Athenaeum</div>
                <div style="font-size:0.65rem; letter-spacing:0.14em; text-transform:uppercase; color:#f6cb73; font-weight:700;">Admin Console</div>
            </div>
        </a>

        <div class="admin-nav-group">Operations</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/admin" class="${adminSection == 'dashboard' ? 'active' : ''}">Overview &amp; Analytics</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/loans" class="${adminSection == 'loans' ? 'active' : ''}">Circulation &amp; Loans</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/members" class="${adminSection == 'members' ? 'active' : ''}">Members &amp; Roles</a></li>
        </ul>

        <div class="admin-nav-group" style="margin-top:0.5rem;">Catalog &amp; Data</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/admin/books" class="${adminSection == 'books' ? 'active' : ''}">Books Inventory</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/authors" class="${adminSection == 'authors' ? 'active' : ''}">Authors Registry</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/audit" class="${adminSection == 'audit' ? 'active' : ''}">Audit Trail</a></li>
        </ul>

        <div class="admin-nav-group" style="margin-top:0.5rem;">Integrations</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/api/books/export.csv">Export Catalog CSV</a></li>
            <li><a href="${pageContext.request.contextPath}/api/stats" target="_blank">JSON Telemetry API</a></li>
            <li><a href="${pageContext.request.contextPath}/h2-console" target="_blank">H2 Database Console</a></li>
        </ul>

        <div class="admin-sidebar-footer">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary btn-sm btn-block" style="background:rgba(255,255,255,0.06); color:#e2e8f0; border-color:rgba(255,255,255,0.12);">View Public Site ↗</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm btn-block">Sign Out</a>
        </div>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <div style="display:flex; align-items:center; gap:12px;">
                <button type="button" class="icon-btn mobile-menu-btn" id="adminSidebarToggle" aria-label="Toggle Sidebar">☰</button>
                <div>
                    <div style="font-size:0.72rem; text-transform:uppercase; letter-spacing:0.1em; color:var(--gold); font-weight:700;">Athenaeum Control Plane</div>
                    <div style="font-weight:700; font-size:1.05rem;">${pageTitle}</div>
                </div>
            </div>
            <div style="display:flex; align-items:center; gap:10px;">
                <button type="button" class="icon-btn" onclick="toggleTheme()" title="Toggle Theme"><span data-theme-icon>☀</span></button>
                <a href="${pageContext.request.contextPath}/admin/books/new" class="btn btn-primary btn-sm">+ Add Book</a>
                <c:if test="${not empty currentUser}">
                    <span class="user-pill">
                        <span class="user-avatar">${currentUser.initials}</span>
                        <span>${currentUser.fullName}</span>
                    </span>
                </c:if>
            </div>
        </header>

        <main class="admin-content">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" data-autoclose><span>${successMessage}</span></div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" data-autoclose><span>${errorMessage}</span></div>
            </c:if>

