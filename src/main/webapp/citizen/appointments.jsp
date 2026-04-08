<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Appointments – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="citizen-page">
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Citizen Portal</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp">👤 My Profile</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list" class="active">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 My Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>🏥 My Appointments</h2>
    <a href="${pageContext.request.contextPath}/appointment?action=new" class="btn btn-primary">+ Book Appointment</a>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Appointment booked successfully! Awaiting confirmation.</div>
  <% } %>

  <div class="card">
    <% if (appointments.isEmpty()) { %>
      <div style="text-align:center;padding:3rem;color:var(--muted);">
        <div style="font-size:3rem;margin-bottom:1rem;">🏥</div>
        <p>No appointments booked yet.</p>
        <a href="${pageContext.request.contextPath}/appointment?action=new" class="btn btn-primary" style="margin-top:1rem;">Book an Appointment</a>
      </div>
    <% } else { %>
      <div class="table-wrap">
        <table class="sc-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Doctor</th>
              <th>Specialization</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <% for (Appointment a : appointments) {
               String sc = "Confirmed".equals(a.getStatus()) ? "badge-confirmed" :
                           "Cancelled".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending"; %>
              <tr>
                <td>#<%= a.getAppointmentId() %></td>
                <td><%= a.getDoctorName() %></td>
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
</main>
</body>
</html>
