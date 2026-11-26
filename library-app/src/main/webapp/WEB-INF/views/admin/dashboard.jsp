<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Overview — Athenaeum</title>
    <jsp:include page="/WEB-INF/views/fragments/head.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/admin-layout-start.jsp"/>

<!-- KPI Grid -->
<div class="kpi-grid">
    <div class="kpi-card">
        <div class="kpi-label">Catalog Titles</div>
        <div class="kpi-num">${stats.totalBooks}</div>
        <div class="kpi-meta">${stats.availableCopies}/${stats.totalCopies} shelf copies free</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Active Circulation</div>
        <div class="kpi-num" style="color:var(--sky);">${stats.openLoans}</div>
        <div class="kpi-meta">${stats.utilizationPct}% stock utilization</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Waitlist Holds</div>
        <div class="kpi-num" style="color:var(--accent);">${stats.openHolds}</div>
        <div class="kpi-meta">${stats.readyHolds} ready · ${stats.waitingHolds} waiting</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Overdue &amp; Fines</div>
        <div class="kpi-num" style="color:${stats.overdueLoans > 0 ? 'var(--danger)' : 'var(--emerald)'};">${stats.overdueLoans}</div>
        <div class="kpi-meta">$${stats.unpaidFines} unpaid fines</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Registered Members</div>
        <div class="kpi-num" style="color:var(--emerald);">${stats.totalMembers}</div>
        <div class="kpi-meta">${stats.activeMembers} active cards</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Avg Rating</div>
        <div class="kpi-num" style="color:var(--accent);">${stats.avgRating} ★</div>
        <div class="kpi-meta">${stats.returnedLoans} completed loans</div>
    </div>
</div>

<!-- Charts Row -->
<div class="dashboard-split">
    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Collection Mix</div>
                <h2 class="serif" style="font-size:1.55rem;">Catalog by Genre</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary btn-sm">Manage Stock</a>
        </div>
        <div class="chart-box">
            <canvas id="genreChart"></canvas>
        </div>
    </div>

    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Operations Telemetry</div>
                <h2 class="serif" style="font-size:1.55rem;">Circulation &amp; Holds Health</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/loans" class="btn btn-gold-outline btn-sm">Circulation Desk</a>
        </div>
        <div class="chart-box">
            <canvas id="loanChart"></canvas>
        </div>
    </div>
</div>

<!-- Recent Loans & Audit Feed -->
<div class="dashboard-split">
    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Front Desk</div>
                <h2 class="serif" style="font-size:1.55rem;">Recent Loans &amp; Holds</h2>
            </div>
            <div style="display:flex; gap:6px;">
                <a href="${pageContext.request.contextPath}/admin/holds" class="btn btn-gold-outline btn-sm">Holds (${stats.openHolds})</a>
                <a href="${pageContext.request.contextPath}/admin/loans" class="btn btn-secondary btn-sm">All Loans</a>
            </div>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Pass / Due</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="loan" items="${recentLoans}">
                        <tr>
                            <td><strong>${loan.book.title}</strong></td>
                            <td>${loan.member.fullName}</td>
                            <td class="mono" style="font-size:0.78rem;">${loan.pickupCode} · ${loan.formattedDueDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${loan.status == 'OVERDUE'}"><span class="badge badge-danger">Overdue</span></c:when>
                                    <c:when test="${loan.status == 'RETURNED'}"><span class="badge badge-neutral">Returned</span></c:when>
                                    <c:otherwise><span class="badge badge-emerald">Active (${loan.readingProgress}%)</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Live Stream</div>
                <h2 class="serif" style="font-size:1.55rem;">Audit Activity</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/audit" class="btn btn-secondary btn-sm">Full Log</a>
        </div>
        <div style="max-height:310px; overflow-y:auto;">
            <c:forEach var="log" items="${recentActivity}">
                <div class="timeline-item">
                    <span class="timeline-dot"></span>
                    <div style="flex:1;">
                        <div style="display:flex; justify-content:space-between; gap:8px; font-size:0.82rem;">
                            <strong>${log.actorName}</strong>
                            <span class="mono" style="color:var(--text-muted); font-size:0.72rem;">${log.formattedTime}</span>
                        </div>
                        <div style="font-size:0.83rem; color:var(--text-soft);">${log.details}</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof Chart === 'undefined') return;

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var labelColor = isDark ? '#a4b1c5' : '#4c5667';
        var gridColor = isDark ? 'rgba(255,255,255,0.08)' : 'rgba(20,25,35,0.08)';

        var genreLabels = [
            <c:forEach var="g" items="${genreBreakdown}" varStatus="st">'${g[0]}'<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        var genreCounts = [
            <c:forEach var="g" items="${genreBreakdown}" varStatus="st">${g[1]}<c:if test="${!st.last}">,</c:if></c:forEach>
        ];

        var palette = ['#c25e28', '#0e7c5b', '#1d6fa5', '#6246c9', '#d97706', '#be185d', '#0f766e', '#c8333a', '#4338ca'];

        new Chart(document.getElementById('genreChart'), {
            type: 'doughnut',
            data: {
                labels: genreLabels,
                datasets: [{ data: genreCounts, backgroundColor: palette, borderWidth: 0, hoverOffset: 8 }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '62%',
                plugins: {
                    legend: {
                        position: 'right',
                        labels: { color: labelColor, boxWidth: 12, padding: 12, font: { family: 'Plus Jakarta Sans', size: 12 } }
                    }
                }
            }
        });

        new Chart(document.getElementById('loanChart'), {
            type: 'bar',
            data: {
                labels: ['Active Loans', 'Overdue', 'Open Holds', 'Returned', 'On Shelf'],
                datasets: [{
                    label: 'Count',
                    data: [${stats.activeLoans}, ${stats.overdueLoans}, ${stats.openHolds}, ${stats.returnedLoans}, ${stats.availableCopies}],
                    backgroundColor: ['#1d6fa5', '#c8333a', '#c25e28', '#6246c9', '#0e7c5b'],
                    borderRadius: 8,
                    maxBarThickness: 42
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
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
