<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Bill, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    if (bills == null) bills = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Bills – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-page">
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Admin Panel</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin?action=users">👥 Manage Users</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list" class="active">💡 Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>💡 Manage Utility Bills</h2>
  </div>

  <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">✅ Bill added successfully!</div>
  <% } %>

  <!-- Add Bill Form -->
  <div class="card" style="margin-bottom:1.5rem;">
    <div class="card-title">➕ Issue New Bill</div>
    <form action="${pageContext.request.contextPath}/bill" method="post">
      <input type="hidden" name="action" value="add">
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
  <div class="card">
    <div class="card-title">All Bills</div>
    <div class="table-wrap">
      <table class="sc-table">
        <thead>
          <tr><th>#</th><th>Citizen</th><th>Type</th><th>Amount</th><th>Due Date</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% if (bills.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:2rem;">No bills issued yet.</td></tr>
          <% } else { for (Bill b : bills) { %>
            <tr>
              <td>#<%= b.getBillId() %></td>
              <td><%= b.getUserName() != null ? b.getUserName() : "Citizen #" + b.getUserId() %></td>
              <td><%= b.getType() %></td>
              <td style="font-weight:600;">₹<%= b.getAmount() %></td>
              <td><%= b.getDueDate() %></td>
              <td><span class="badge <%= "Paid".equals(b.getStatus()) ? "badge-paid" : "badge-unpaid" %>"><%= b.getStatus() %></span></td>
            </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</main>
</body>
</html>
