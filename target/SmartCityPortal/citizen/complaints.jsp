<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Complaint, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    if (complaints == null) complaints = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Complaints – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
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
    <h2>📋 My Complaints</h2>
    <a href="${pageContext.request.contextPath}/complaint?action=new" class="btn btn-primary">+ New Complaint</a>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Complaint submitted successfully! We'll look into it.</div>
  <% } %>

  <div class="card">
    <% if (complaints.isEmpty()) { %>
      <div style="text-align:center;padding:3rem;color:var(--muted);">
        <div style="font-size:3rem;margin-bottom:1rem;">📭</div>
        <p>No complaints filed yet.</p>
        <a href="${pageContext.request.contextPath}/complaint?action=new" class="btn btn-primary" style="margin-top:1rem;">File Your First Complaint</a>
      </div>
    <% } else { %>
      <div class="table-wrap">
        <table class="sc-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Category</th>
              <th>Description</th>
              <th>Location</th>
              <th>Status</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody>
            <% for (Complaint c : complaints) { %>
              <% String statusClass = "Resolved".equals(c.getStatus()) ? "badge-resolved" :
                                     "In Progress".equals(c.getStatus()) ? "badge-progress" : "badge-pending"; %>
              <tr>
                <td>#<%= c.getComplaintId() %></td>
                <td><%= c.getCategory() %></td>
                <td style="max-width:250px;"><%= c.getDescription() %></td>
                <td><%= c.getLocation() %></td>
                <td><span class="badge <%= statusClass %>"><%= c.getStatus() %></span></td>
                <td style="color:var(--muted);font-size:.8rem;"><%= c.getDate() %></td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    <% } %>
  </div>
</main>
</body>
</html>
