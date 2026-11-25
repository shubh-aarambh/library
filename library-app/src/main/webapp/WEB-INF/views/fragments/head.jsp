<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
<script>
    (function(){
        var t = localStorage.getItem('athenaeum-theme');
        if (t) document.documentElement.setAttribute('data-theme', t);
    })();
</script>
<script defer src="${pageContext.request.contextPath}/static/js/app.js"></script>

