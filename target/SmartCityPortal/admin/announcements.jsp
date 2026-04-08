<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Announcement, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    if (announcements == null) announcements = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Announcements – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Admin Panel</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 Manage Users</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/announcement" class="active">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>📢 Manage Announcements</h2>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Announcement posted successfully!</div>
  <% } %>

  <!-- Post Announcement Form -->
  <div class="card" style="margin-bottom:1.5rem;">
    <div class="card-title">📝 Post New Announcement</div>
    <form action="${pageContext.request.contextPath}/announcement" method="post">
      <input type="hidden" name="action" value="add">
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
        <textarea name="content" class="form-control" rows="3" required
                  placeholder="Write the announcement message..."></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Post Announcement</button>
    </form>
  </div>

  <!-- Announcements List -->
  <% if (announcements.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:2rem;color:var(--muted);">No announcements posted yet.</div>
  <% } else { for (Announcement a : announcements) {
       String catClass = "Alert".equals(a.getCategory()) ? "badge-alert" :
                         "Event".equals(a.getCategory()) ? "badge-event" :
                         "Maintenance".equals(a.getCategory()) ? "badge-maintenance" : "badge-general"; %>
    <div class="announce-card">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:.75rem;">
        <div style="display:flex;align-items:center;gap:.75rem;">
          <span class="badge <%= catClass %>"><%= a.getCategory() %></span>
          <span style="color:var(--muted);font-size:.8rem;"><%= a.getCreatedAt() %></span>
        </div>
        <form action="${pageContext.request.contextPath}/announcement" method="post" style="display:inline;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" value="<%= a.getId() %>">
          <button type="submit" class="btn btn-danger btn-sm"
                  onclick="return confirm('Delete this announcement?')">🗑️ Delete</button>
        </form>
      </div>
      <h3 style="font-size:1rem;font-weight:600;margin-bottom:.5rem;"><%= a.getTitle() %></h3>
      <p style="color:var(--muted);font-size:.875rem;"><%= a.getContent() %></p>
    </div>
  <% } } %>
</main>
</body>
</html>
