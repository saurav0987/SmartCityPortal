<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, com.smartcity.model.Bill, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    if (bills == null) bills = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Bills – Admin</title>
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
    <a href="${pageContext.request.contextPath}/admin/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills" class="active">💡 Bills</a>
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
      <h2>💡 Manage Utility Bills</h2>
      <div class="sub">Issue new bills and track payment status</div>
    </div>
    <div class="user-chip">
      <div class="avatar avatar-admin">A</div>
      <div>
        <div style="font-size:.8rem;font-weight:700;color:var(--text);"><%= admin.getName() %></div>
        <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
      </div>
    </div>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Bill issued successfully!</div>
  <% } %>

  <!-- Issue New Bill -->
  <div class="card reveal" style="margin-bottom:1.5rem;">
    <div class="card-title">➕ Issue New Bill</div>
    <form action="${pageContext.request.contextPath}/admin/add-bill" method="post">
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:1rem;">
        <div class="form-group" style="margin:0;">
          <label>Citizen ID *</label>
          <input type="number" name="userId" class="form-control" required placeholder="e.g. 2">
        </div>
        <div class="form-group" style="margin:0;">
          <label>Bill Type *</label>
          <select name="type" class="form-control" required>
            <option value="">— Select —</option>
            <option value="Electricity">Electricity</option>
            <option value="Water">Water</option>
            <option value="Property Tax">Property Tax</option>
            <option value="Sewage">Sewage</option>
          </select>
        </div>
        <div class="form-group" style="margin:0;">
          <label>Amount (₹) *</label>
          <input type="number" name="amount" step="0.01" class="form-control" required placeholder="e.g. 500">
        </div>
        <div class="form-group" style="margin:0;">
          <label>Due Date *</label>
          <input type="date" name="dueDate" class="form-control" required>
        </div>
        <div class="form-group" style="margin:0;display:flex;align-items:flex-end;">
          <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Issue Bill</button>
        </div>
      </div>
    </form>
  </div>

  <!-- Bills Table -->
  <div class="card reveal">
    <div class="section-header">
      <div class="card-title" style="margin:0;border:none;padding:0;">
        All Bills
        <span class="badge badge-general" style="margin-left:.5rem;font-size:.68rem;"><%= bills.size() %> total</span>
      </div>
    </div>
    <div class="filter-bar" style="margin-top:.75rem;">
      <button class="filter-pill active" data-filter="all">All</button>
      <button class="filter-pill" data-filter="unpaid">Unpaid</button>
      <button class="filter-pill" data-filter="paid">Paid</button>
      <input class="filter-search" placeholder="🔍 Search bills...">
    </div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr><th>#</th><th>Citizen</th><th>Type</th><th>Amount</th><th>Due Date</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% if (bills.isEmpty()) { %>
            <tr><td colspan="6">
              <div class="empty-state">
                <div class="ei">📄</div>
                <p>No bills issued yet.</p>
              </div>
            </td></tr>
          <% } else { for (Bill b : bills) { %>
            <tr>
              <td style="color:var(--muted);font-weight:600;">#<%= b.getBillId() %></td>
              <td><%= b.getUserName() != null ? b.getUserName() : "Citizen #" + (b.getUser() != null ? b.getUser().getId() : "??") %></td>
              <td><%= b.getType() %></td>
              <td style="font-weight:700;color:var(--text);">₹<%= b.getAmount() %></td>
              <td style="color:var(--muted);"><%= b.getDueDate() %></td>
              <td><span class="badge <%= "Paid".equals(b.getStatus()) ? "badge-paid" : "badge-unpaid" %>"><%= b.getStatus() %></span></td>
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
