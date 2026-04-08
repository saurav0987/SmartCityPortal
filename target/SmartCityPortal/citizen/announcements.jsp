<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Announcement, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    if (announcements == null) announcements = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Announcements – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Citizen Portal</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp">👤 My Profile</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 My Bills</a>
    <a href="${pageContext.request.contextPath}/announcement" class="active">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>📢 City Announcements</h2>
  </div>

  <% if (announcements.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:3rem;color:var(--muted);">
      <div style="font-size:3rem;margin-bottom:1rem;">📭</div>
      <p>No announcements at the moment. Check back later!</p>
    </div>
  <% } else {
       for (Announcement a : announcements) {
         String catClass = "Alert".equals(a.getCategory()) ? "badge-alert" :
                           "Event".equals(a.getCategory()) ? "badge-event" :
                           "Maintenance".equals(a.getCategory()) ? "badge-maintenance" : "badge-general";
  %>
    <div class="announce-card">
      <div style="display:flex;align-items:center;gap:.75rem;margin-bottom:.75rem;">
        <span class="badge <%= catClass %>"><%= a.getCategory() %></span>
        <span style="color:var(--muted);font-size:.8rem;">
          <%= a.getCreatedAt() %>
          <% if (a.getPostedByName() != null) { %> · by <%= a.getPostedByName() %><% } %>
        </span>
      </div>
      <h3 style="font-size:1rem;font-weight:600;margin-bottom:.5rem;"><%= a.getTitle() %></h3>
      <p style="color:var(--muted);font-size:.875rem;line-height:1.6;"><%= a.getContent() %></p>
    </div>
  <% } } %>
</main>
</body>
</html>
