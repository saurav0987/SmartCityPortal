<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
    String displayName = user.getName().length() > 16 ? user.getName().substring(0,15)+"…" : user.getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Book Appointment – Smart City Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
  <style>
    .form-hint {
      font-size: .72rem; color: var(--muted);
      margin-top: .28rem;
    }
    .info-banner {
      background: var(--info-light);
      border: 1px solid #bae6fd;
      border-left: 3px solid var(--info);
      border-radius: var(--r-sm);
      padding: .75rem 1rem;
      font-size: .81rem; color: #0c4a6e;
      margin-bottom: 1.35rem;
      display: flex; align-items: flex-start; gap: .6rem;
    }
  </style>
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
      <h2>🏥 Book Appointment</h2>
      <div class="sub">Schedule a doctor consultation at the city hospital</div>
    </div>
    <a href="${pageContext.request.contextPath}/citizen/appointments" class="btn btn-outline">← Back to Appointments</a>
  </div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="info-banner reveal">
    <span>ℹ️</span>
    <span>Appointments are confirmed within 24 hours by the hospital administration. You will see the status update in your appointments list.</span>
  </div>

  <div class="card reveal" style="max-width:640px;">
    <div class="card-title">Appointment Details</div>
    <form action="${pageContext.request.contextPath}/citizen/book-appointment" method="post">

      <div class="form-group">
        <label for="doctorName">Doctor Name *</label>
        <input type="text" id="doctorName" name="doctorName" class="form-control"
               required placeholder="e.g. Dr. Sunita Mehta">
        <div class="form-hint">Enter the full name of the doctor you wish to consult.</div>
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
          <input type="date" id="date" name="date" class="form-control"
                 required min="<%= java.time.LocalDate.now() %>">
          <div class="form-hint">Select a future date.</div>
        </div>
        <div class="form-group">
          <label for="time">Preferred Time *</label>
          <input type="time" id="time" name="time" class="form-control" required>
          <div class="form-hint">OPD hours: 9:00 AM – 5:00 PM</div>
        </div>
      </div>

      <div class="form-group">
        <label for="notes">Notes / Symptoms</label>
        <textarea id="notes" name="notes" class="form-control" rows="3"
                  placeholder="Briefly describe your symptoms or reason for visit..."></textarea>
      </div>

      <div style="display:flex;gap:.75rem;margin-top:.25rem;">
        <button type="submit" class="btn btn-primary">Book Appointment</button>
        <a href="${pageContext.request.contextPath}/citizen/appointments" class="btn btn-outline">Cancel</a>
      </div>
    </form>
  </div>

</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
</body>
</html>
