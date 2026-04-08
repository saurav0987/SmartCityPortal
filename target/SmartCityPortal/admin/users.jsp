<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Users – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Admin Panel</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users" class="active">👥 Manage Users</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 Complaints</a>
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
    <h2>👥 Manage Citizens</h2>
  </div>

  <div class="card">
    <div class="table-wrap">
      <table class="sc-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Role</th>
          </tr>
        </thead>
        <tbody>
          <% if (users.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:2rem;">No citizens registered.</td></tr>
          <% } else { for (User u : users) { %>
            <tr>
              <td>#<%= u.getId() %></td>
              <td><%= u.getName() %></td>
              <td><%= u.getEmail() %></td>
              <td><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
              <td style="max-width:200px;"><%= u.getAddress() != null ? u.getAddress() : "—" %></td>
              <td><span class="badge badge-confirmed"><%= u.getRole() %></span></td>
            </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</main>
</body>
</html>
