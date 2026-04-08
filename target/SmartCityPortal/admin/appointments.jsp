<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Appointment, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Appointments – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Admin Panel</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 Manage Users</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list" class="active">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>🏥 Manage Appointments</h2>
  </div>

  <div class="card">
    <div class="table-wrap">
      <table class="sc-table">
        <thead>
          <tr><th>#</th><th>Citizen</th><th>Doctor</th><th>Specialization</th><th>Date</th><th>Time</th><th>Status</th><th>Update</th></tr>
        </thead>
        <tbody>
          <% if (appointments.isEmpty()) { %>
            <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:2rem;">No appointments booked.</td></tr>
          <% } else { for (Appointment a : appointments) {
               String sc = "Confirmed".equals(a.getStatus()) ? "badge-confirmed" :
                           "Cancelled".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending"; %>
            <tr>
              <td>#<%= a.getAppointmentId() %></td>
              <td><%= a.getUserName() != null ? a.getUserName() : "Citizen" %></td>
              <td><%= a.getDoctorName() %></td>
              <td style="color:var(--muted);"><%= a.getSpecialization() != null ? a.getSpecialization() : "—" %></td>
              <td><%= a.getDate() %></td>
              <td><%= a.getTime() %></td>
              <td><span class="badge <%= sc %>"><%= a.getStatus() %></span></td>
              <td>
                <form action="${pageContext.request.contextPath}/appointment" method="post" style="display:flex;gap:.4rem;">
                  <input type="hidden" name="action" value="updateStatus">
                  <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
                  <select name="status" class="form-control" style="padding:.3rem .5rem;font-size:.8rem;width:130px;">
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
</main>
</body>
</html>
