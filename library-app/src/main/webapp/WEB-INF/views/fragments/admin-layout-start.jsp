<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="admin-shell">
    <aside class="admin-sidebar" id="adminSidebar">
        <a href="${pageContext.request.contextPath}/admin" class="admin-brand">
            <div class="serif" style="font-size:1.35rem; font-weight:600; line-height:1.1;">Athenaeum</div>
            <div style="font-size:0.72rem; color:#9ca3af; margin-top:2px;">Staff Operations</div>
        </a>

        <div class="admin-nav-label">Desk</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/admin" class="${adminSection == 'dashboard' ? 'active' : ''}">Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/loans" class="${adminSection == 'loans' ? 'active' : ''}">Loans &amp; Returns</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/holds" class="${adminSection == 'holds' ? 'active' : ''}">Waitlist Holds</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/members" class="${adminSection == 'members' ? 'active' : ''}">Members</a></li>
        </ul>

        <div class="admin-nav-label">Catalog</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/admin/books" class="${adminSection == 'books' ? 'active' : ''}">Books &amp; Stock</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/authors" class="${adminSection == 'authors' ? 'active' : ''}">Authors</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/audit" class="${adminSection == 'audit' ? 'active' : ''}">Activity Log</a></li>
        </ul>

        <div class="admin-nav-label">Tools</div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/books/joined" target="_blank">SQL/JPQL Join ↗</a></li>
            <li><a href="${pageContext.request.contextPath}/api/books/export.csv">Export CSV</a></li>
            <li><a href="${pageContext.request.contextPath}/h2-console" target="_blank">H2 Console ↗</a></li>
        </ul>

        <div class="admin-sidebar-foot">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary btn-sm btn-block" style="background:rgba(255,255,255,0.08); color:#f3f4f6; border-color:rgba(255,255,255,0.14);">Public Library ↗</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm btn-block" style="color:#f06a60;">Sign out</a>
        </div>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <div style="display:flex; align-items:center; gap:10px;">
                <button type="button" class="theme-btn mobile-menu-btn" id="adminSidebarToggle" aria-label="Sidebar">☰</button>
                <strong style="font-size:0.98rem;">${pageTitle}</strong>
            </div>
            <div style="display:flex; align-items:center; gap:10px;">
                <button type="button" class="theme-btn" onclick="toggleTheme()" title="Toggle theme"><span data-theme-icon>☾</span></button>
                <a href="${pageContext.request.contextPath}/admin/books/new" class="btn btn-primary btn-sm">Add book</a>
                <c:if test="${not empty currentUser}">
                    <span style="font-size:0.84rem; color:var(--ink-2); font-weight:500;">${currentUser.fullName}</span>
                </c:if>
            </div>
        </header>

        <main class="admin-content">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
