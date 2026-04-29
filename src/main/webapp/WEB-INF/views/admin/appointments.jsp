<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, com.smartcity.model.Appointment, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Appointments – Admin</title>
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
    <a href="${pageContext.request.contextPath}/admin/complaint-map" style="display:flex;align-items:center;gap:8px;">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments" class="active">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/admin/announcements">📢 Announcements</a>
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
      <h2>🏥 Manage Appointments</h2>
      <div class="sub">Review and update citizen appointment status</div>
    </div>
    <div class="user-chip">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div style="font-size:.8rem;font-weight:700;color:var(--text);"><%= admin.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
      </div>
    </div>
  </div>

  <div class="card reveal">
    <div class="section-header">
      <div class="card-title" style="margin:0;border:none;padding:0;">
        All Appointments
        <span class="badge badge-general" style="margin-left:.5rem;font-size:.68rem;"><%= appointments.size() %> total</span>
      </div>
    </div>
    <div style="display:flex;justify-content:space-between;align-items:center;margin-top:.75rem;">
      <div class="filter-bar" style="margin-bottom:0;">
        <button class="filter-pill active" data-filter="all">All</button>
        <button class="filter-pill" data-filter="pending">Pending</button>
        <button class="filter-pill" data-filter="confirmed">Confirmed</button>
        <button class="filter-pill" data-filter="cancelled">Cancelled</button>
      </div>
      <div class="calendar-toggle">
        <button class="cal-btn active" data-view="table">📊 Table</button>
        <button class="cal-btn" data-view="calendar">📅 Calendar</button>
      </div>
    </div>
    <div class="calendar-container" style="display:none;"></div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr>
            <th>#</th><th>Citizen</th><th>Doctor</th><th>Specialization</th>
            <th>Date</th><th>Time</th><th>Status</th><th>Update</th>
          </tr>
        </thead>
        <tbody>
          <% if (appointments.isEmpty()) { %>
            <tr><td colspan="8">
              <div class="empty-state">
                <div class="ei">🏥</div>
                <p>No appointments booked yet.</p>
              </div>
            </td></tr>
          <% } else { for (Appointment a : appointments) {
               String sc = "Confirmed".equals(a.getStatus()) ? "badge-confirmed" :
                           "Cancelled".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending"; %>
            <tr>
              <td style="color:var(--muted);font-weight:600;">#<%= a.getAppointmentId() %></td>
              <td><%= a.getUserName() != null ? a.getUserName() : "Citizen" %></td>
              <td style="font-weight:600;"><%= a.getDoctorName() %></td>
              <td style="color:var(--muted);"><%= a.getSpecialization() != null ? a.getSpecialization() : "—" %></td>
              <td><%= a.getDate() %></td>
              <td><%= a.getTime() %></td>
              <td><span class="badge <%= sc %>"><%= a.getStatus() %></span></td>
              <td>
                <form action="${pageContext.request.contextPath}/admin/update-appointment" method="post" style="display:flex;gap:.4rem;">
                  <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
                  <select name="status" class="form-control" style="padding:.32rem .5rem;font-size:.78rem;width:125px;">
                    <option value="Pending"   <%= "Pending".equals(a.getStatus())   ? "selected" : "" %>>Pending</option>
                    <option value="Confirmed" <%= "Confirmed".equals(a.getStatus()) ? "selected" : "" %>>Confirmed</option>
                    <option value="Cancelled" <%= "Cancelled".equals(a.getStatus()) ? "selected" : "" %>>Cancelled</option>
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
</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
