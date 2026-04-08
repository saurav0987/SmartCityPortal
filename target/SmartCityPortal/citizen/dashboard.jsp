<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"CITIZEN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-row">
      <div class="brand-icon">🏙️</div>
      <div>
        <h4>SmartCity Portal</h4>
        <small>Citizen Panel</small>
      </div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp" class="active">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp">👤 My Profile</a>
    <div class="nav-label">City Services</div>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 Utility Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-mini">
      <div class="avatar"><%= initial %></div>
      <div>
        <div class="u-name"><%= user.getName().length() > 16 ? user.getName().substring(0,15)+"…" : user.getName() %></div>
        <div class="u-role">Citizen</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">Logout</a>
  </div>
</aside>

<main class="main-content">
<div class="content-inner">

  <div class="topbar">
    <div>
      <h2>Dashboard</h2>
      <div class="sub">Hello, <%= user.getName() %> — here's your overview</div>
    </div>
    <div class="user-chip">
      <div class="avatar"><%= initial %></div>
      <div>
        <div style="font-size:.8rem;font-weight:600;color:#e5e7eb;"><%= user.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Citizen Account</div>
      </div>
    </div>
  </div>

  <!-- Quick Actions -->
  <div class="stats-grid">
    <a href="${pageContext.request.contextPath}/complaint?action=new" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">📋</span>
          <span class="badge badge-citizen">Civic</span>
        </div>
        <div class="s-num" style="font-size:1rem;">File Complaint</div>
        <div class="s-label">Road, Water, Electricity, Garbage</div>
        <span class="s-link">Go →</span>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/complaint?action=list" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">🔍</span>
          <span class="badge badge-pending">Track</span>
        </div>
        <div class="s-num" style="font-size:1rem;">My Complaints</div>
        <div class="s-label">View status updates</div>
        <span class="s-link">View list →</span>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/appointment?action=new" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">🏥</span>
          <span class="badge badge-confirmed">Health</span>
        </div>
        <div class="s-num" style="font-size:1rem;">Book Appointment</div>
        <div class="s-label">City hospital doctors</div>
        <span class="s-link">Book now →</span>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/bill?action=list" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">💡</span>
          <span class="badge badge-unpaid">Bills</span>
        </div>
        <div class="s-num" style="font-size:1rem;">Utility Bills</div>
        <div class="s-label">View &amp; pay pending bills</div>
        <span class="s-link">Open bills →</span>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/announcement" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">📢</span>
          <span class="badge badge-general">Notice</span>
        </div>
        <div class="s-num" style="font-size:1rem;">City Notices</div>
        <div class="s-label">Official announcements</div>
        <span class="s-link">Read →</span>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/citizen/profile.jsp" style="text-decoration:none;">
      <div class="stat-card">
        <div class="s-top">
          <span class="s-icon">👤</span>
        </div>
        <div class="s-num" style="font-size:1rem;">My Profile</div>
        <div class="s-label">View account details</div>
        <span class="s-link">View →</span>
      </div>
    </a>
  </div>

  <!-- Profile Summary -->
  <div class="card" style="max-width:560px;">
    <div class="card-title">Account Details</div>
    <div class="info-row"><span class="lbl">Name</span><span class="val"><%= user.getName() %></span></div>
    <div class="info-row"><span class="lbl">Email</span><span class="val"><%= user.getEmail() %></span></div>
    <div class="info-row"><span class="lbl">Phone</span><span class="val"><%= (user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "Not provided" %></span></div>
    <div class="info-row"><span class="lbl">Address</span><span class="val"><%= (user.getAddress() != null && !user.getAddress().isEmpty()) ? user.getAddress() : "Not provided" %></span></div>
    <div class="info-row"><span class="lbl">Account Type</span><span class="val"><span class="badge badge-citizen">Citizen</span></span></div>
  </div>

</div>
</main>

</body>
</html>
