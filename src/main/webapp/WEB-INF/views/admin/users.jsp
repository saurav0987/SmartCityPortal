<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Citizens – Admin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
</head>
<body class="admin-page">

<button class="sidebar-toggle" id="sidebarToggle" aria-label="Toggle navigation">
  <div class="bar"><span></span><span></span><span></span></div>
</button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="b-icon" style="background:#7c3aed;">🛡️</div>
    <div><h4>SmartCity Portal</h4><small>Admin Panel</small></div>
  </div>
  <nav>
    <div class="nav-label">Overview</div>
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users" class="active">👥 All Citizens</a>
    <div class="nav-label">Manage</div>
    <a href="${pageContext.request.contextPath}/admin/complaints">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/admin/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/admin/announcements">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-mini">
      <div class="avatar avatar-admin">A</div>
      <div><div class="u-name"><%= admin.getName() %></div><div class="u-role">Administrator</div></div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">Logout</a>
  </div>
</aside>

<main class="main-content">
<div class="content-inner">
  <div class="topbar">
    <div>
      <h2>👥 Manage Citizens</h2>
      <div class="sub">All registered citizen accounts</div>
    </div>
    <div class="user-chip">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div style="font-size:.8rem;font-weight:700;color:var(--text);"><%= admin.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
      </div>
    </div>
  </div>

  <div class="card reveal">
    <div class="section-header">
      <div class="card-title" style="margin:0;border:none;padding:0;">
        Registered Citizens
        <span class="badge badge-general" style="margin-left:.5rem;font-size:.68rem;"><%= users.size() %> accounts</span>
      </div>
    </div>
    <div class="filter-bar" style="margin-top:.75rem;">
      <button class="filter-pill active" data-filter="all">All</button>
      <button class="filter-pill" data-filter="citizen">Citizens</button>
      <button class="filter-pill" data-filter="admin">Admins</button>
      <input class="filter-search" placeholder="🔍 Search users...">
    </div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr>
            <th>#</th><th>Name</th><th>Email</th>
            <th>Phone</th><th>Address</th><th>Role</th>
          </tr>
        </thead>
        <tbody>
          <% if (users.isEmpty()) { %>
            <tr><td colspan="6">
              <div class="empty-state">
                <div class="ei">👥</div>
                <p>No citizens registered yet.</p>
              </div>
            </td></tr>
          <% } else { for (User u : users) { %>
            <tr>
              <td style="color:var(--muted);font-weight:600;">#<%= u.getId() %></td>
              <td style="font-weight:600;"><%= u.getName() %></td>
              <td style="color:var(--muted);"><%= u.getEmail() %></td>
              <td><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
              <td style="max-width:200px;color:var(--muted);font-size:.79rem;"><%= u.getAddress() != null ? u.getAddress() : "—" %></td>
              <td><span class="badge <%= "ADMIN".equals(u.getRole()) ? "badge-admin" : "badge-citizen" %>"><%= u.getRole() %></span></td>
            </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
