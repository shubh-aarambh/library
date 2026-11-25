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
        <div class="kpi-meta">${stats.availableCopies}/${stats.totalCopies} copies on shelf</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Active Circulation</div>
        <div class="kpi-num" style="color:var(--sky);">${stats.openLoans}</div>
        <div class="kpi-meta">${stats.utilizationPct}% inventory utilization</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Overdue &amp; Fines</div>
        <div class="kpi-num" style="color:${stats.overdueLoans > 0 ? 'var(--danger)' : 'var(--emerald)'};">${stats.overdueLoans}</div>
        <div class="kpi-meta">$${stats.unpaidFines} unpaid fines</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Authors Registry</div>
        <div class="kpi-num">${stats.totalAuthors}</div>
        <div class="kpi-meta">${stats.totalGenres} distinct genres</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Registered Members</div>
        <div class="kpi-num" style="color:var(--emerald);">${stats.totalMembers}</div>
        <div class="kpi-meta">${stats.activeMembers} active cards</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Catalog Rating</div>
        <div class="kpi-num" style="color:var(--gold);">${stats.avgRating} ★</div>
        <div class="kpi-meta">${stats.returnedLoans} completed loans</div>
    </div>
</div>

<!-- Analytics Charts -->
<div class="dashboard-split">
    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Collection Mix</div>
                <h2 class="serif" style="font-size:1.35rem;">Catalog Distribution by Genre</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary btn-sm">Manage Books</a>
        </div>
        <div class="chart-box">
            <canvas id="genreChart"></canvas>
        </div>
    </div>

    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Circulation Health</div>
                <h2 class="serif" style="font-size:1.35rem;">Loan Lifecycle Overview</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/loans" class="btn btn-gold-outline btn-sm">Open Desk</a>
        </div>
        <div class="chart-box">
            <canvas id="loanChart"></canvas>
        </div>
    </div>
</div>

<!-- Recent Loans + Audit Feed -->
<div class="dashboard-split">
    <div class="card">
        <div class="section-header" style="margin-bottom:1rem;">
            <div>
                <div class="section-kicker">Circulation Desk</div>
                <h2 class="serif" style="font-size:1.35rem;">Recent Loans</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/loans" class="btn btn-secondary btn-sm">View All →</a>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Member</th>
                        <th>Due Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="loan" items="${recentLoans}">
                        <tr>
                            <td><strong>${loan.book.title}</strong></td>
                            <td>${loan.member.fullName}</td>
                            <td class="mono" style="font-size:0.8rem;">${loan.formattedDueDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${loan.status == 'OVERDUE'}"><span class="badge badge-danger">Overdue</span></c:when>
                                    <c:when test="${loan.status == 'RETURNED'}"><span class="badge badge-neutral">Returned</span></c:when>
                                    <c:otherwise><span class="badge badge-emerald">Active</span></c:otherwise>
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
                <div class="section-kicker">Live Telemetry</div>
                <h2 class="serif" style="font-size:1.35rem;">Audit Activity Stream</h2>
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

        var genreLabels = [
            <c:forEach var="g" items="${genreBreakdown}" varStatus="st">'${g[0]}'<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        var genreCounts = [
            <c:forEach var="g" items="${genreBreakdown}" varStatus="st">${g[1]}<c:if test="${!st.last}">,</c:if></c:forEach>
        ];

        var palette = ['#e5a93c', '#38bdf8', '#10b981', '#a78bfa', '#f97316', '#ec4899', '#14b8a6', '#ef4444', '#6366f1'];

        new Chart(document.getElementById('genreChart'), {
            type: 'doughnut',
            data: {
                labels: genreLabels,
                datasets: [{
                    data: genreCounts,
                    backgroundColor: palette,
                    borderWidth: 0,
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '62%',
                plugins: {
                    legend: {
                        position: 'right',
                        labels: { color: '#9fb0c8', boxWidth: 12, padding: 14, font: { family: 'Plus Jakarta Sans', size: 12 } }
                    }
                }
            }
        });

        new Chart(document.getElementById('loanChart'), {
            type: 'bar',
            data: {
                labels: ['Active Loans', 'Overdue', 'Returned', 'Available Copies'],
                datasets: [{
                    label: 'Count',
                    data: [${stats.activeLoans}, ${stats.overdueLoans}, ${stats.returnedLoans}, ${stats.availableCopies}],
                    backgroundColor: ['#38bdf8', '#ef4444', '#10b981', '#e5a93c'],
                    borderRadius: 8,
                    maxBarThickness: 46
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(148,163,184,0.1)' }, ticks: { color: '#9fb0c8' } },
                    x: { grid: { display: false }, ticks: { color: '#9fb0c8' } }
                }
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/fragments/admin-layout-end.jsp"/>
</body>
</html>

