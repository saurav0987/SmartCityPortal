<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Complaint, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    if (complaints == null) complaints = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Complaints – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Admin Panel</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 Manage Users</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list" class="active">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>📋 Manage Complaints</h2>
  </div>

  <div class="card">
    <div class="table-wrap">
      <table class="sc-table">
        <thead>
          <tr><th>#</th><th>Citizen</th><th>Category</th><th>Description</th><th>Location</th><th>Date</th><th>Status</th><th>Update</th></tr>
        </thead>
        <tbody>
          <% if (complaints.isEmpty()) { %>
            <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:2rem;">No complaints filed.</td></tr>
          <% } else { for (Complaint c : complaints) {
               String sc = "Resolved".equals(c.getStatus()) ? "badge-resolved" :
                           "In Progress".equals(c.getStatus()) ? "badge-progress" : "badge-pending"; %>
            <tr>
              <td>#<%= c.getComplaintId() %></td>
              <td><%= c.getUserName() != null ? c.getUserName() : "Citizen" %></td>
              <td><%= c.getCategory() %></td>
              <td style="max-width:200px;font-size:.8rem;"><%= c.getDescription() %></td>
              <td><%= c.getLocation() %></td>
              <td style="color:var(--muted);font-size:.8rem;"><%= c.getDate() %></td>
              <td><span class="badge <%= sc %>"><%= c.getStatus() %></span></td>
              <td>
                <form action="${pageContext.request.contextPath}/complaint" method="post" style="display:flex;gap:.4rem;">
                  <input type="hidden" name="action" value="updateStatus">
                  <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                  <select name="status" class="form-control" style="padding:.3rem .5rem;font-size:.8rem;width:130px;">
                    <option value="Pending"     <%= "Pending".equals(c.getStatus())     ? "selected" : "" %>>Pending</option>
                    <option value="In Progress" <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                    <option value="Resolved"    <%= "Resolved".equals(c.getStatus())    ? "selected" : "" %>>Resolved</option>
                  </select>
                  <button type="submit" class="btn btn-primary btn-sm">Save</button>
                </form>
              </td>
            </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</main>
</body>
</html>
