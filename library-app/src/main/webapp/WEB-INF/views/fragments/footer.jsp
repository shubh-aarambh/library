<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <strong class="serif" style="color:var(--text); font-size:1rem;">Athenaeum Library</strong>
            <span style="margin-left:8px;">Spring Boot · JPA · H2 · Role-Based Circulation &amp; Admin Platform</span>
        </div>
        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/books">Catalog</a>
            <a href="${pageContext.request.contextPath}/authors">Authors</a>
            <a href="${pageContext.request.contextPath}/books/joined">JPQL Join</a>
            <a href="${pageContext.request.contextPath}/api/books" target="_blank">REST API</a>
            <a href="${pageContext.request.contextPath}/api/books/export.csv">Export CSV</a>
            <a href="${pageContext.request.contextPath}/admin">Admin Console</a>
            <a href="${pageContext.request.contextPath}/h2-console" target="_blank">H2 Console</a>
        </div>
    </div>
</footer>

