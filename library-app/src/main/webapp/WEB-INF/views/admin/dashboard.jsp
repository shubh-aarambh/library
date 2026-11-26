<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Overview — Staff Admin</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<div class="kpi-row">
    <div class="kpi-box">
        <div class="k-label">Catalog Titles</div>
        <div class="k-val">${stats.totalBooks}</div>
        <div class="k-sub">${stats.availableCopies} of ${stats.totalCopies} copies on shelf</div>
    </div>
    <div class="kpi-box">
        <div class="k-label">Active Loans</div>
        <div class="k-val">${stats.openLoans}</div>
        <div class="k-sub">${stats.utilizationPct}% stock utilization</div>
    </div>
    <div class="kpi-box">
        <div class="k-label">Waitlist Holds</div>
        <div class="k-val">${stats.openHolds}</div>
        <div class="k-sub">${stats.readyHolds} ready · ${stats.waitingHolds} waiting</div>
    </div>
    <div class="kpi-box">
        <div class="k-label">Overdue</div>
        <div class="k-val" style="color:${stats.overdueLoans > 0 ? 'var(--danger)' : 'var(--ink)'};">${stats.overdueLoans}</div>
        <div class="k-sub">$${stats.unpaidFines} unpaid fines</div>
    </div>
    <div class="kpi-box">
        <div class="k-label">Members</div>
        <div class="k-val">${stats.totalMembers}</div>
        <div class="k-sub">${stats.activeMembers} active cards</div>
    </div>
</div>

<div class="split-2">
    <div class="panel">
        <div class="section-head" style="margin-bottom:1rem;">
            <h2 style="font-size:1.25rem;">Collection by Genre</h2>
            <a href="${pageContext.request.contextPath}/admin/books">Manage stock →</a>
        </div>
        <div class="chart-box"><canvas id="genreChart"></canvas></div>
    </div>

    <div class="panel">
        <div class="section-head" style="margin-bottom:1rem;">
            <h2 style="font-size:1.25rem;">Circulation Summary</h2>
            <a href="${pageContext.request.contextPath}/admin/loans">Loans desk →</a>
        </div>
        <div class="chart-box"><canvas id="loanChart"></canvas></div>
    </div>
</div>

<div class="split-2">
    <div class="panel" style="padding:1.25rem;">
        <div class="section-head" style="margin-bottom:0.85rem;">
            <h2 style="font-size:1.25rem;">Recent Loans</h2>
            <a href="${pageContext.request.contextPath}/admin/loans">View all →</a>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr><th>Book</th><th>Member</th><th>Due</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="loan" items="${recentLoans}">
                        <tr>
                            <td><strong>${loan.book.title}</strong></td>
                            <td>${loan.member.fullName}</td>
                            <td class="mono" style="font-size:0.8rem;">${loan.formattedDueDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${loan.status == 'OVERDUE'}"><span class="tag tag-red">Overdue</span></c:when>
                                    <c:when test="${loan.status == 'RETURNED'}"><span class="tag">Returned</span></c:when>
                                    <c:otherwise><span class="tag tag-green">Active (${loan.readingProgress}%)</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="panel" style="padding:1.25rem;">
        <div class="section-head" style="margin-bottom:0.85rem;">
            <h2 style="font-size:1.25rem;">Recent Activity</h2>
            <a href="${pageContext.request.contextPath}/admin/audit">Full log →</a>
        </div>
        <div style="max-height:290px; overflow-y:auto;">
            <c:forEach var="log" items="${recentActivity}">
                <div style="padding:9px 0; border-bottom:1px solid var(--border); font-size:0.84rem;">
                    <div style="display:flex; justify-content:space-between; margin-bottom:2px;">
                        <strong>${log.actorName}</strong>
                        <span class="mono" style="font-size:0.74rem; color:var(--ink-3);">${log.formattedTime}</span>
                    </div>
                    <div style="color:var(--ink-2);">${log.details}</div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof Chart === 'undefined') return;
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var labelColor = isDark ? '#b1b8c2' : '#4b525c';
        var gridColor = isDark ? 'rgba(255,255,255,0.08)' : 'rgba(17,19,21,0.07)';

        var genreLabels = [<c:forEach var="g" items="${genreBreakdown}" varStatus="st">'${g[0]}'<c:if test="${!st.last}">,</c:if></c:forEach>];
        var genreCounts = [<c:forEach var="g" items="${genreBreakdown}" varStatus="st">${g[1]}<c:if test="${!st.last}">,</c:if></c:forEach>];
        var palette = ['#164e3b', '#2b6cb0', '#9a5411', '#5b46c8', '#b42318', '#0f766e', '#64748b', '#7c2d12', '#374151'];

        new Chart(document.getElementById('genreChart'), {
            type: 'doughnut',
            data: { labels: genreLabels, datasets: [{ data: genreCounts, backgroundColor: palette, borderWidth: 0 }] },
            options: {
                responsive: true, maintainAspectRatio: false, cutout: '64%',
                plugins: { legend: { position: 'right', labels: { color: labelColor, boxWidth: 11, font: { family: 'Inter', size: 12 } } } }
            }
        });

        new Chart(document.getElementById('loanChart'), {
            type: 'bar',
            data: {
                labels: ['Active', 'Overdue', 'Holds', 'Returned', 'On Shelf'],
                datasets: [{
                    data: [${stats.activeLoans}, ${stats.overdueLoans}, ${stats.openHolds}, ${stats.returnedLoans}, ${stats.availableCopies}],
                    backgroundColor: ['#164e3b', '#b42318', '#9a5411', '#64748b', '#2b6cb0'],
                    borderRadius: 4, maxBarThickness: 38
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: gridColor }, ticks: { color: labelColor } },
                    x: { grid: { display: false }, ticks: { color: labelColor } }
                }
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>
