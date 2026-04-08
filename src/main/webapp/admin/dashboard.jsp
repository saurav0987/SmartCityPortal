<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Complaint, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Object totalUsers  = request.getAttribute("totalUsers");
    Object totalComp   = request.getAttribute("totalComplaints");
    Object pendComp    = request.getAttribute("pendingComplaints");
    Object totalAppt   = request.getAttribute("totalAppointments");
    Object unpaidBills = request.getAttribute("unpaidBills");
    Object totalAnn    = request.getAttribute("totalAnnouncements");
    List<Complaint> recent = (List<Complaint>) request.getAttribute("recentComplaints");
    if (recent == null) recent = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">

<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-row">
      <div class="brand-icon" style="background:#7c3aed;">🛡️</div>
      <div>
        <h4>SmartCity Portal</h4>
        <small>Admin Panel</small>
      </div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-label">Overview</div>
    <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="active">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 All Citizens</a>
    <div class="nav-label">Manage</div>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-mini">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div class="u-name"><%= admin.getName() %></div>
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
      <div class="sub">Logged in as <%= admin.getName() %> &mdash; Administrator</div>
    </div>
    <div class="user-chip">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div style="font-size:.8rem;font-weight:600;color:#e5e7eb;"><%= admin.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
      </div>
    </div>
  </div>

  <!-- Stats -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="s-top"><span class="s-icon">👥</span></div>
      <div class="s-num"><%= totalUsers   != null ? totalUsers   : 0 %></div>
      <div class="s-label">Registered Citizens</div>
      <a href="${pageContext.request.contextPath}/admin?action=users" class="s-link">View all →</a>
    </div>

    <div class="stat-card">
      <div class="s-top"><span class="s-icon">📋</span></div>
      <div class="s-num"><%= totalComp    != null ? totalComp    : 0 %></div>
      <div class="s-label">Total Complaints</div>
      <a href="${pageContext.request.contextPath}/complaint?action=list" class="s-link">Manage →</a>
    </div>

    <div class="stat-card">
      <div class="s-top"><span class="s-icon">⏳</span><span class="badge badge-pending">Pending</span></div>
      <div class="s-num"><%= pendComp     != null ? pendComp     : 0 %></div>
      <div class="s-label">Complaints Pending</div>
      <a href="${pageContext.request.contextPath}/complaint?action=list" class="s-link">Review →</a>
    </div>

    <div class="stat-card">
      <div class="s-top"><span class="s-icon">🏥</span></div>
      <div class="s-num"><%= totalAppt    != null ? totalAppt    : 0 %></div>
      <div class="s-label">Total Appointments</div>
      <a href="${pageContext.request.contextPath}/appointment?action=list" class="s-link">View →</a>
    </div>

    <div class="stat-card">
      <div class="s-top"><span class="s-icon">💡</span><span class="badge badge-unpaid">Unpaid</span></div>
      <div class="s-num"><%= unpaidBills  != null ? unpaidBills  : 0 %></div>
      <div class="s-label">Bills Unpaid</div>
      <a href="${pageContext.request.contextPath}/bill?action=list" class="s-link">Manage →</a>
    </div>

    <div class="stat-card">
      <div class="s-top"><span class="s-icon">📢</span></div>
      <div class="s-num"><%= totalAnn     != null ? totalAnn     : 0 %></div>
      <div class="s-label">Announcements Posted</div>
      <a href="${pageContext.request.contextPath}/announcement" class="s-link">Manage →</a>
    </div>
  </div>

  <!-- Recent Complaints -->
  <div class="card">
    <div class="section-header">
      <div class="card-title" style="margin-bottom:0;border:none;padding:0;">Recent Complaints</div>
      <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-outline btn-sm">View All</a>
    </div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr>
            <th>ID</th><th>Citizen</th><th>Category</th>
            <th>Location</th><th>Status</th><th>Date</th>
          </tr>
        </thead>
        <tbody>
          <% int cnt = 0;
             for (Complaint c : recent) {
               if (cnt++ >= 5) break;
               String sc = "Resolved".equals(c.getStatus()) ? "badge-resolved" :
                           "In Progress".equals(c.getStatus()) ? "badge-progress" : "badge-pending"; %>
            <tr>
              <td style="color:var(--muted);">#<%= c.getComplaintId() %></td>
              <td><%= c.getUserName() != null ? c.getUserName() : "—" %></td>
              <td><%= c.getCategory() %></td>
              <td style="color:var(--muted);"><%= c.getLocation() %></td>
              <td><span class="badge <%= sc %>"><%= c.getStatus() %></span></td>
              <td style="color:var(--muted);font-size:.72rem;"><%= c.getDate() %></td>
            </tr>
          <% } %>
          <% if (recent.isEmpty()) { %>
            <tr><td colspan="6"><div class="empty-state"><div class="ei">📭</div><p>No complaints filed yet.</p></div></td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

</div>
</main>

</body>
</html>
