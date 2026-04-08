<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Bill, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    if (bills == null) bills = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bills – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="citizen-page">
<aside class="sidebar">
  <div class="sidebar-brand"><h4>🏙️ Smart City</h4><small>Citizen Portal</small></div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/citizen/dashboard.jsp">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile.jsp">👤 My Profile</a>
    <a href="${pageContext.request.contextPath}/complaint?action=list">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/appointment?action=list">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/bill?action=list" class="active">💡 My Bills</a>
    <a href="${pageContext.request.contextPath}/announcement">📢 Announcements</a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%;justify-content:center;">🚪 Logout</a>
  </div>
</aside>
<main class="main-content">
  <div class="topbar">
    <h2>💡 My Utility Bills</h2>
  </div>

  <% if (request.getParameter("paid") != null) { %>
    <div class="alert alert-success">✅ Bill marked as paid!</div>
  <% } %>

  <div class="card">
    <% if (bills.isEmpty()) { %>
      <div style="text-align:center;padding:3rem;color:var(--muted);">
        <div style="font-size:3rem;margin-bottom:1rem;">📄</div>
        <p>No bills issued to your account yet.</p>
      </div>
    <% } else { %>
      <div class="table-wrap">
        <table class="sc-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Type</th>
              <th>Amount (₹)</th>
              <th>Due Date</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <% for (Bill b : bills) { %>
              <tr>
                <td>#<%= b.getBillId() %></td>
                <td><%= b.getType() %></td>
                <td style="font-weight:600;">₹<%= b.getAmount() %></td>
                <td><%= b.getDueDate() %></td>
                <td>
                  <span class="badge <%= "Paid".equals(b.getStatus()) ? "badge-paid" : "badge-unpaid" %>">
                    <%= b.getStatus() %>
                  </span>
                </td>
                <td>
                  <% if ("Unpaid".equals(b.getStatus())) { %>
                    <form action="${pageContext.request.contextPath}/bill" method="post" style="display:inline;">
                      <input type="hidden" name="action" value="pay">
                      <input type="hidden" name="billId" value="<%= b.getBillId() %>">
                      <button type="submit" class="btn btn-success btn-sm"
                              onclick="return confirm('Pay ₹<%= b.getAmount() %> for <%= b.getType() %>?')">
                        Pay Now
                      </button>
                    </form>
                  <% } else { %>
                    <span style="color:var(--muted);font-size:.8rem;">✅ Paid</span>
                  <% } %>
                </td>
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
