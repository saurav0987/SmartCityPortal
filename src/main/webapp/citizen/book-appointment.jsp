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
  <title>Book Appointment – Smart City Portal</title>
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
    <div>
      <h2>🏥 Book Appointment</h2>
      <p class="text-muted" style="font-size:.85rem;margin-top:.2rem;">Schedule a doctor consultation at the city hospital.</p>
    </div>
    <a href="${pageContext.request.contextPath}/appointment?action=list" class="btn btn-outline">← Back</a>
  </div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="card" style="max-width:640px;">
    <form action="${pageContext.request.contextPath}/appointment" method="post">
      <input type="hidden" name="action" value="book">

      <div class="form-group">
        <label for="doctorName">Doctor Name *</label>
        <input type="text" id="doctorName" name="doctorName" class="form-control" required
               placeholder="e.g. Dr. Sunita Mehta">
      </div>

      <div class="form-group">
        <label for="specialization">Specialization</label>
        <select id="specialization" name="specialization" class="form-control">
          <option value="">— Select specialization —</option>
          <option value="General Physician">General Physician</option>
          <option value="Cardiologist">Cardiologist</option>
          <option value="Dermatologist">Dermatologist</option>
          <option value="Orthopedic">Orthopedic</option>
          <option value="ENT">ENT</option>
          <option value="Pediatrician">Pediatrician</option>
          <option value="Neurologist">Neurologist</option>
          <option value="Gynecologist">Gynecologist</option>
        </select>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
        <div class="form-group">
          <label for="date">Appointment Date *</label>
          <input type="date" id="date" name="date" class="form-control" required
                 min="<%= java.time.LocalDate.now() %>">
        </div>
        <div class="form-group">
          <label for="time">Preferred Time *</label>
          <input type="time" id="time" name="time" class="form-control" required>
        </div>
      </div>

      <div class="form-group">
        <label for="notes">Notes / Symptoms</label>
        <textarea id="notes" name="notes" class="form-control" rows="3"
                  placeholder="Briefly describe your symptoms or reason for visit..."></textarea>
      </div>

      <div style="display:flex;gap:1rem;">
        <button type="submit" class="btn btn-primary">Book Appointment</button>
        <a href="${pageContext.request.contextPath}/appointment?action=list" class="btn btn-outline">Cancel</a>
      </div>
    </form>
  </div>
</main>
</body>
</html>
