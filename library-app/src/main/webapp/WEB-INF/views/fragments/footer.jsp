<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <strong class="serif" style="color:var(--text); font-size:1.2rem;">Athenaeum</strong>
            <span style="margin-left:8px;">Smart Campus &amp; Digital Library · Borrow, Reserve, Preview &amp; Track</span>
        </div>
        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/books">Catalog</a>
            <a href="${pageContext.request.contextPath}/authors">Authors</a>
            <a href="${pageContext.request.contextPath}/my-library">My Library</a>
            <a href="${pageContext.request.contextPath}/admin">Librarian Admin</a>
            <a href="${pageContext.request.contextPath}/books/joined">Data Join View</a>
            <a href="${pageContext.request.contextPath}/api/books" target="_blank">REST API</a>
        </div>
    </div>
</footer>
