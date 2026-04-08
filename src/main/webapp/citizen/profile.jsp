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
  <title>My Profile – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="citizen-page">
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Citizen Portal</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp" class="active">👤 My Profile</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 My Complaints</a>
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
    <h2>👤 My Profile</h2>
    <div class="user-info">
      <div class="avatar"><%= user.getName().charAt(0) %></div>
      <span style="font-size:.875rem;"><%= user.getName() %></span>
    </div>
  </div>

  <div class="card" style="max-width:600px;">
    <div style="display:flex;align-items:center;gap:1.5rem;margin-bottom:1.5rem;">
      <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#1a56db,#0ea5e9);display:flex;align-items:center;justify-content:center;font-size:2rem;font-weight:700;color:#fff;">
        <%= user.getName().charAt(0) %>
      </div>
      <div>
        <div style="font-size:1.3rem;font-weight:700;"><%= user.getName() %></div>
        <div style="color:var(--muted);">Citizen</div>
      </div>
    </div>

    <div class="card-title">Account Information</div>
    <table class="sc-table">
      <tr>
        <td style="color:var(--muted);width:150px;">👤 Full Name</td>
        <td><%= user.getName() %></td>
      </tr>
      <tr>
        <td style="color:var(--muted);">📧 Email</td>
        <td><%= user.getEmail() %></td>
      </tr>
      <tr>
        <td style="color:var(--muted);">📱 Phone</td>
        <td><%= user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "Not provided" %></td>
      </tr>
      <tr>
        <td style="color:var(--muted);">🏠 Address</td>
        <td><%= user.getAddress() != null && !user.getAddress().isEmpty() ? user.getAddress() : "Not provided" %></td>
      </tr>
      <tr>
        <td style="color:var(--muted);">🔑 Role</td>
        <td><span class="badge badge-confirmed"><%= user.getRole() %></span></td>
      </tr>
    </table>

    <div style="margin-top:1.5rem;">
      <p class="text-muted" style="font-size:.8rem;">To update your profile details, please contact the city administration.</p>
    </div>
  </div>
</main>
</body>
</html>
