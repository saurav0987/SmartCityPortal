<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>File Complaint – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="citizen-page">
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Citizen Portal</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp">👤 My Profile</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list" class="active">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 My Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <div>
      <h2>📋 File a Complaint</h2>
      <p class="text-muted" style="font-size:.85rem;margin-top:.2rem;">Report any civic issue and we'll address it promptly.</p>
    </div>
    <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-outline">← Back to Complaints</a>
  </div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="card" style="max-width:640px;">
    <form action="${pageContext.request.contextPath}/complaint" method="post">
      <input type="hidden" name="action" value="add">

      <div class="form-group">
        <label for="category">Complaint Category *</label>
        <select id="category" name="category" class="form-control" required>
          <option value="">— Select a category —</option>
          <option value="Road">🛣️ Road (Pothole, Damage)</option>
          <option value="Water">💧 Water (Supply Issue)</option>
          <option value="Electricity">⚡ Electricity (Power Cut)</option>
          <option value="Garbage">🗑️ Garbage (Collection Issue)</option>
          <option value="Other">📌 Other</option>
        </select>
      </div>

      <div class="form-group">
        <label for="location">Location *</label>
        <input type="text" id="location" name="location" class="form-control" required
               placeholder="e.g. MG Road, Near City Park, Block A">
      </div>

      <div class="form-group">
        <label for="description">Description *</label>
        <textarea id="description" name="description" class="form-control" rows="5" required
                  placeholder="Describe the issue in detail (what, when, impact)..."></textarea>
      </div>

      <div style="display:flex;gap:1rem;">
        <button type="submit" class="btn btn-primary">Submit Complaint</button>
        <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-outline">Cancel</a>
      </div>
    </form>
  </div>
</main>
</body>
</html>
