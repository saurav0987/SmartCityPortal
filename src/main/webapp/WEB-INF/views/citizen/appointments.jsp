<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, com.smartcity.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = new java.util.ArrayList<>();
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
    String displayName = user.getName().length() > 16 ? user.getName().substring(0,15)+"…" : user.getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Appointments – Smart City Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
</head>
<body class="citizen-page">

<button class="sidebar-toggle" id="sidebarToggle" aria-label="Toggle navigation">
  <div class="bar"><span></span><span></span><span></span></div>
</button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="b-icon">🏙️</div>
    <div><h4>SmartCity Portal</h4><small>Citizen Panel</small></div>
  </div>
  <nav>
    <div class="nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/citizen/dashboard">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile">👤 My Profile</a>
    <div class="nav-label">City Services</div>
    <a href="${pageContext.request.contextPath}/citizen/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/citizen/complaints">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments" class="active">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/citizen/bills">💡 My Bills</a>
    <a href="${pageContext.request.contextPath}/citizen/announcements">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-mini">
      <div class="avatar"><%= initial %></div>
      <div><div class="u-name"><%= displayName %></div><div class="u-role">Citizen</div></div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">Logout</a>
  </div>
</aside>

<main class="main-content">
<div class="content-inner">
  <div class="topbar">
    <div>
      <h2>🏥 My Appointments</h2>
      <div class="sub">Your hospital appointment bookings</div>
    </div>
    <a href="${pageContext.request.contextPath}/citizen/book-appointment" class="btn btn-primary">+ Book Appointment</a>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Appointment booked successfully! Awaiting confirmation.</div>
  <% } %>

  <div class="card reveal">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
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
    <% if (appointments.isEmpty()) { %>
      <div class="empty-state">
        <div class="ei">🏥</div>
        <p>No appointments booked yet.</p>
        <a href="${pageContext.request.contextPath}/citizen/book-appointment" class="btn btn-primary">Book an Appointment</a>
      </div>
    <% } else { %>
      <div class="table-wrap">
        <table class="sc-table">
          <thead>
            <tr>
              <th>#</th><th>Doctor</th><th>Specialization</th>
              <th>Date</th><th>Time</th><th>Status</th>
            </tr>
          </thead>
          <tbody>
            <% for (Appointment a : appointments) {
               String sc = "Confirmed".equals(a.getStatus()) ? "badge-confirmed" :
                           "Cancelled".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending"; %>
              <tr>
                <td style="color:var(--muted);font-weight:600;">#<%= a.getAppointmentId() %></td>
                <td style="font-weight:600;"><%= a.getDoctorName() %></td>
                <td style="color:var(--muted);"><%= a.getSpecialization() != null ? a.getSpecialization() : "—" %></td>
                <td><%= a.getDate() %></td>
                <td><%= a.getTime() %></td>
                <td><span class="badge <%= sc %>"><%= a.getStatus() %></span></td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    <% } %>
  </div>
</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
