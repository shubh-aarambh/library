<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle} — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/navbar.jsp"/>

<main class="main-content">
    <div class="container">
        <div class="section-header">
            <div>
                <div class="section-kicker">Catalog Record</div>
                <h1 class="section-title">${pageTitle}</h1>
                <p class="section-subtitle">Maintain bibliographic metadata, shelf placement, and inventory counts</p>
            </div>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary btn-sm">← Back to Catalog</a>
        </div>

        <div class="card" style="max-width:820px; margin:0 auto;">
            <form:form action="${pageContext.request.contextPath}${formAction}" method="post" modelAttribute="book">
                <div class="form-group">
                    <label for="title">Book Title *</label>
                    <form:input path="title" id="title" cssClass="form-control" placeholder="e.g. The Old Man and the Sea"/>
                    <form:errors path="title" cssClass="error-msg"/>
                </div>

                <div class="form-grid-3">
                    <div class="form-group">
                        <label for="genre">Genre *</label>
                        <form:input path="genre" id="genre" cssClass="form-control" placeholder="e.g. Sci-Fi, Fantasy"/>
                        <form:errors path="genre" cssClass="error-msg"/>
                    </div>
                    <div class="form-group">
                        <label for="publishedYear">Published Year *</label>
                        <form:input path="publishedYear" id="publishedYear" type="number" cssClass="form-control" placeholder="1965"/>
                        <form:errors path="publishedYear" cssClass="error-msg"/>
                    </div>
                    <div class="form-group">
                        <label for="pages">Pages</label>
                        <form:input path="pages" id="pages" type="number" cssClass="form-control" placeholder="320"/>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="isbn">ISBN *</label>
                        <form:input path="isbn" id="isbn" cssClass="form-control" placeholder="ISBN-9780684801223"/>
                        <form:errors path="isbn" cssClass="error-msg"/>
                    </div>
                    <div class="form-group">
                        <label for="author.id">Author *</label>
                        <form:select path="author.id" id="author.id" cssClass="form-control">
                            <form:option value="" label="— Select an Author —"/>
                            <c:forEach var="a" items="${authors}">
                                <form:option value="${a.id}" label="${a.name} (${a.nationality})"/>
                            </c:forEach>
                        </form:select>
                        <form:errors path="author" cssClass="error-msg"/>
                    </div>
                </div>

                <div class="form-grid-3">
                    <div class="form-group">
                        <label for="totalCopies">Total Copies</label>
                        <form:input path="totalCopies" id="totalCopies" type="number" min="1" max="500" cssClass="form-control"/>
                        <form:errors path="totalCopies" cssClass="error-msg"/>
                    </div>
                    <div class="form-group">
                        <label for="availableCopies">Available Copies</label>
                        <form:input path="availableCopies" id="availableCopies" type="number" min="0" max="500" cssClass="form-control"/>
                    </div>
                    <div class="form-group">
                        <label for="shelfLocation">Shelf Location</label>
                        <form:input path="shelfLocation" id="shelfLocation" cssClass="form-control" placeholder="A-12"/>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="language">Language</label>
                        <form:input path="language" id="language" cssClass="form-control" placeholder="English"/>
                    </div>
                    <div class="form-group">
                        <label for="coverColor">Hardcover Palette</label>
                        <form:select path="coverColor" id="coverColor" cssClass="form-control">
                            <form:option value="linear-gradient(145deg, #1e3a5f 0%, #0f172a 100%)" label="Midnight Navy"/>
                            <form:option value="linear-gradient(145deg, #1b4332 0%, #081c15 100%)" label="Forest Emerald"/>
                            <form:option value="linear-gradient(145deg, #7f1d1d 0%, #1c0a0a 100%)" label="Crimson Velvet"/>
                            <form:option value="linear-gradient(145deg, #b45309 0%, #451a03 100%)" label="Desert Amber"/>
                            <form:option value="linear-gradient(145deg, #3b0764 0%, #1e1b4b 100%)" label="Royal Amethyst"/>
                            <form:option value="linear-gradient(145deg, #115e59 0%, #042f2e 100%)" label="Ocean Teal"/>
                            <form:option value="linear-gradient(145deg, #831843 0%, #3b0724 100%)" label="Burgundy Rose"/>
                        </form:select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Synopsis / Description</label>
                    <form:textarea path="description" id="description" cssClass="form-control" rows="4"
                                   placeholder="Concise editorial summary of the volume..."/>
                </div>

                <div class="form-group" style="display:flex; align-items:center; gap:10px;">
                    <form:checkbox path="featured" id="featured"/>
                    <label for="featured" style="margin:0; text-transform:none; letter-spacing:0; font-size:0.9rem;">
                        Feature this book on the Homepage Staff Picks shelf
                    </label>
                </div>

                <div style="display:flex; gap:12px; margin-top:1.5rem;">
                    <button type="submit" class="btn btn-primary">${buttonLabel}</button>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">Cancel</a>
                </div>
            </form:form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
</body>
</html>
