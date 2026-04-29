<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="admin" value="${sessionScope.loggedUser}" />
<c:if test="${empty admin || admin.role != 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard – Smart City Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="admin-page">

<!-- Mobile sidebar toggle -->
<button class="sidebar-toggle" id="sidebarToggle" aria-label="Toggle navigation">
  <div class="bar"><span></span><span></span><span></span></div>
</button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="b-icon" style="background:#7c3aed;">🛡️</div>
    <div>
      <h4>SmartCity Portal</h4>
      <small>Admin Panel</small>
    </div>
  </div>
  <nav>
    <div class="nav-label">Overview</div>
    <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="active">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 All Citizens</a>
    <div class="nav-label">Manage</div>
    <a href="${pageContext.request.contextPath}/admin/complaints">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/admin/complaint-map" style="display:flex;align-items:center;gap:8px;">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/admin/announcements">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-mini">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div class="u-name">${admin.name}</div>
        <div class="u-role">Administrator</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">Logout</a>
  </div>
</aside>

<main class="main-content">
<div class="content-inner">

  <div class="topbar">
    <div>
      <h2>Admin Dashboard</h2>
      <div class="sub">Logged in as ${admin.name} &mdash; Administrator</div>
    </div>
    <div class="topbar-actions">
      <div class="search-trigger" data-tooltip="Search (Ctrl+K)"><span>🔍</span> Search... <kbd>Ctrl+K</kbd></div>
      <div class="notif-wrap">
        <button class="notif-bell" data-tooltip="Notifications">🔔<span class="notif-badge">5</span></button>
        <div class="notif-dropdown"><div class="notif-header"><span>Notifications</span><button class="notif-clear">Clear all</button></div><div class="notif-list"></div></div>
      </div>
      <button class="theme-toggle" data-tooltip="Toggle theme">🌙</button>
        <div class="user-chip">
          <div class="avatar avatar-admin">A</div>
          <div>
            <div style="font-size:.8rem;font-weight:700;color:var(--text);">${admin.name}</div>
            <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
          </div>
        </div>
    </div>
  </div>

  <!-- Stats Grid -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">👥</span></div>
      <div class="s-num" data-target="${totalUsers}">${totalUsers}</div>
      <div class="s-label">Registered Citizens</div>
      <a href="${pageContext.request.contextPath}/admin?action=users" class="s-link">View all →</a>
    </div>
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">📋</span></div>
      <div class="s-num" data-target="${totalComplaints}">${totalComplaints}</div>
      <div class="s-label">Total Complaints</div>
      <a href="${pageContext.request.contextPath}/admin/complaints" class="s-link">Manage →</a>
    </div>
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">⏳</span><span class="badge badge-pending">Pending</span></div>
      <div class="s-num" data-target="${pendingComplaints}">${pendingComplaints}</div>
      <div class="s-label">Complaints Pending</div>
      <a href="${pageContext.request.contextPath}/admin/complaints" class="s-link">Review →</a>
    </div>
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">🏥</span></div>
      <div class="s-num" data-target="${totalAppointments}">${totalAppointments}</div>
      <div class="s-label">Total Appointments</div>
      <a href="${pageContext.request.contextPath}/admin/appointments" class="s-link">View →</a>
    </div>
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">💡</span><span class="badge badge-unpaid">Unpaid</span></div>
      <div class="s-num" data-target="${unpaidBills}">${unpaidBills}</div>
      <div class="s-label">Bills Unpaid</div>
      <a href="${pageContext.request.contextPath}/admin/bills" class="s-link">Manage →</a>
    </div>
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">📢</span></div>
      <div class="s-num" data-target="${totalAnnouncements}">${totalAnnouncements}</div>
      <div class="s-label">Announcements Posted</div>
      <a href="${pageContext.request.contextPath}/admin/announcements" class="s-link">Manage →</a>
    </div>
  </div>

  <!-- Charts -->
  <div id="enhancedCharts" class="charts-grid">
    <div class="chart-card"><div class="chart-card-title">Complaint Resolution</div><canvas id="chartComplaintStatus"></canvas></div>
    <div class="chart-card"><div class="chart-card-title">Overview</div><canvas id="chartOverview"></canvas></div>
  </div>

  <!-- Recent Complaints -->
  <div class="card reveal">
    <div class="section-header">
      <div class="card-title" style="margin:0;border:none;padding:0;">Recent Complaints</div>
      <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-outline btn-sm">View All</a>
    </div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr>
            <th>#</th><th>Citizen</th><th>Category</th>
            <th>Location</th><th>Status</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${recentComplaints}" varStatus="status">
            <c:if test="${status.index < 5}">
              <c:set var="badgeClass" value="${c.status == 'Resolved' ? 'badge-resolved' : (c.status == 'In Progress' ? 'badge-progress' : 'badge-pending')}" />
              <tr>
                <td style="color:var(--muted);font-weight:600;">#${c.complaintId}</td>
                <td>${not empty c.userName ? c.userName : '—'}</td>
                <td>${c.category}</td>
                <td style="color:var(--muted);">${c.location}</td>
                <td><span class="badge ${badgeClass}">${c.status}</span></td>
                <td style="color:var(--muted);font-size:.72rem;">${c.date}</td>
              </tr>
            </c:if>
          </c:forEach>
          <c:if test="${empty recentComplaints}">
            <tr><td colspan="6">
              <div class="empty-state">
                <div class="ei">📭</div>
                <p>No complaints filed yet.</p>
              </div>
            </td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>

<!-- Search Modal -->
<div class="search-modal">
  <div class="search-box">
    <div class="search-input-wrap"><span class="si-icon">🔍</span><input class="search-input" placeholder="Search..." autofocus><kbd>Esc</kbd></div>
    <div class="search-results"></div>
    <div class="search-footer"><span><kbd>↑↓</kbd> Navigate</span><span><kbd>Enter</kbd> Open</span><span><kbd>Esc</kbd> Close</span></div>
  </div>
</div>

<!-- Shortcuts -->
<div class="shortcuts-modal">
  <div class="shortcuts-box">
    <h3>⌨️ Keyboard Shortcuts</h3>
    <div class="shortcut-row"><span>Search</span><kbd>Ctrl+K</kbd></div>
    <div class="shortcut-row"><span>Toggle Dark Mode</span><kbd>Ctrl+D</kbd></div>
    <div class="shortcut-row"><span>Show Shortcuts</span><kbd>?</kbd></div>
    <div class="shortcut-row"><span>Close Modal</span><kbd>Esc</kbd></div>
  </div>
</div>

<!-- Toast container -->
<div id="toast-container"></div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
