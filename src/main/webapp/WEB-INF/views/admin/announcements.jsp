<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, com.smartcity.model.Announcement, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    if (announcements == null) announcements = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Announcements – Admin</title>
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
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 All Citizens</a>
    <div class="nav-label">Manage</div>
    <a href="${pageContext.request.contextPath}/admin/complaints">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/admin/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/admin/announcements" class="active">📢 Announcements</a>
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
      <h2>📢 Manage Announcements</h2>
      <div class="sub">Post and manage official city announcements</div>
    </div>
    <div class="user-chip">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div style="font-size:.8rem;font-weight:700;color:var(--text);"><%= admin.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
      </div>
    </div>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Announcement posted successfully!</div>
  <% } %>

  <!-- Post Announcement Form -->
  <div class="card reveal" style="margin-bottom:1.5rem;">
    <div class="card-title">📝 Post New Announcement</div>
    <form action="${pageContext.request.contextPath}/admin/add-announcement" method="post">
      <div style="display:grid;grid-template-columns:2fr 1fr;gap:1rem;">
        <div class="form-group" style="margin:0;">
          <label>Title *</label>
          <input type="text" name="title" class="form-control" required placeholder="Announcement title">
        </div>
        <div class="form-group" style="margin:0;">
          <label>Category *</label>
          <select name="category" class="form-control" required>
            <option value="General">General</option>
            <option value="Alert">Alert</option>
            <option value="Event">Event</option>
            <option value="Maintenance">Maintenance</option>
          </select>
        </div>
      </div>
      <div class="form-group" style="margin-top:1rem;">
        <label>Content *</label>
        <textarea name="content" class="form-control" rows="3" required placeholder="Write the announcement message..."></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Post Announcement</button>
    </form>
  </div>

  <!-- Announcements List -->
  <% if (announcements.isEmpty()) { %>
    <div class="card reveal">
      <div class="empty-state">
        <div class="ei">📢</div>
        <p>No announcements posted yet. Post your first announcement above.</p>
      </div>
    </div>
  <% } else { for (Announcement a : announcements) {
       String catClass = "Alert".equals(a.getCategory())       ? "badge-alert" :
                         "Event".equals(a.getCategory())       ? "badge-event" :
                         "Maintenance".equals(a.getCategory()) ? "badge-maintenance" : "badge-general";
       String catBorder = "Alert".equals(a.getCategory())       ? "var(--danger)" :
                          "Event".equals(a.getCategory())       ? "var(--success)" :
                          "Maintenance".equals(a.getCategory()) ? "var(--warning)" : "var(--border-2)"; %>
    <div class="ann-card reveal" style="border-left-color:<%= catBorder %>;">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:.75rem;">
        <div style="display:flex;align-items:center;gap:.75rem;">
          <span class="badge <%= catClass %>"><%= a.getCategory() %></span>
          <span style="color:var(--muted);font-size:.79rem;"><%= a.getCreatedAt() %></span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/delete-announcement" method="post" style="display:inline;">
          <input type="hidden" name="id" value="<%= a.getId() %>">
          <button type="submit" class="btn btn-danger btn-sm"
                  onclick="return confirm('Delete this announcement?')">🗑️ Delete</button>
        </form>
      </div>
      <h3 style="font-size:.95rem;font-weight:700;margin-bottom:.45rem;color:var(--text);"><%= a.getTitle() %></h3>
      <p style="color:var(--muted);font-size:.82rem;line-height:1.65;"><%= a.getContent() %></p>
    </div>
  <% } } %>

</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
