<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User,com.smartcity.model.Bill,java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    if (bills == null) bills = new java.util.ArrayList<>();
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
    java.math.BigDecimal totalDue = java.math.BigDecimal.ZERO;
    int unpaidCount = 0;
    for (Bill b : bills) { if ("Unpaid".equals(b.getStatus()) && b.getAmount() != null) { totalDue = totalDue.add(b.getAmount()); unpaidCount++; } }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Utility Bills – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',-apple-system,sans-serif;background:#f4f6fb;color:#0f172a;-webkit-font-smoothing:antialiased;display:flex;min-height:100vh}
a{text-decoration:none;color:inherit}
.sidebar{width:240px;background:#fff;border-right:1px solid #eef0f5;display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:200}
.sb-brand{padding:20px 18px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;gap:10px}
.sb-brand .bi{width:38px;height:38px;border-radius:10px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;font-size:18px}
.sb-brand h4{font-size:13px;font-weight:800;color:#0f172a}.sb-brand small{font-size:10px;color:#94a3b8}
.sb-nav{flex:1;padding:12px 0}
.sb-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.7px;color:#94a3b8;padding:10px 18px 4px}
.sb-nav a{display:flex;align-items:center;gap:10px;padding:9px 18px;font-size:13px;font-weight:500;color:#64748b;border-left:2px solid transparent;transition:all .15s}
.sb-nav a:hover{color:#0f172a;background:#f8fafc}
.sb-nav a.active{color:#2563eb;background:linear-gradient(90deg,#eff6ff,#f8fafc);border-left-color:#2563eb;font-weight:600}
.sb-foot{padding:14px 16px;border-top:1px solid #f0f2f7}
.sb-user{display:flex;align-items:center;gap:10px;padding:10px 12px;background:#f8fafc;border-radius:10px;margin-bottom:10px}
.sb-user .av{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;color:#fff;font-size:12px;font-weight:800;overflow:hidden}
.sb-user .un{font-size:12px;font-weight:700;color:#0f172a}.sb-user .ur{font-size:10px;color:#94a3b8}
.logout-btn{display:flex;align-items:center;justify-content:center;width:100%;padding:9px;border-radius:8px;border:1px solid #e8eaf0;background:#fff;font-size:12px;font-weight:600;color:#64748b;cursor:pointer;font-family:inherit;transition:all .15s}
.logout-btn:hover{background:#fef2f2;color:#dc2626;border-color:#fecaca}
.main{margin-left:240px;flex:1}
.topbar{background:#fff;border-bottom:1px solid #eef0f5;padding:0 28px;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;box-shadow:0 1px 3px rgba(15,23,42,.04)}
.tb-left h3{font-size:18px;font-weight:800;color:#0f172a;letter-spacing:-.3px}.tb-left p{font-size:12px;color:#94a3b8}
.page{padding:28px}

/* SUMMARY CARDS */
.summary-row{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:14px;margin-bottom:24px}
.sum-card{background:#fff;border-radius:14px;padding:20px;border:1px solid #eef0f5;box-shadow:0 1px 4px rgba(15,23,42,.04);text-align:center;position:relative;overflow:hidden}
.sum-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.sc-red::before{background:linear-gradient(90deg,#ef4444,#f87171)}
.sc-amber::before{background:linear-gradient(90deg,#f59e0b,#fbbf24)}
.sc-green::before{background:linear-gradient(90deg,#10b981,#34d399)}
.sum-val{font-size:26px;font-weight:900;letter-spacing:-1px;margin-bottom:4px}
.sum-lbl{font-size:12px;color:#64748b;font-weight:500}

/* BILL ALERT */
.bill-alert{background:linear-gradient(135deg,#fef3c7,#fffbeb);border:1px solid #fde68a;border-left:4px solid #f59e0b;border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;gap:12px}
.bill-alert-icon{font-size:24px}
.bill-alert-text strong{font-size:13px;font-weight:800;color:#92400e;display:block;margin-bottom:2px}
.bill-alert-text span{font-size:12px;color:#b45309}

.card{background:#fff;border-radius:14px;border:1px solid #eef0f5;padding:24px;box-shadow:0 1px 4px rgba(15,23,42,.04)}
.card-head{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:18px;padding-bottom:14px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;justify-content:space-between}
table{width:100%;border-collapse:collapse;font-size:13px}
th{font-size:11px;text-transform:uppercase;letter-spacing:.5px;color:#94a3b8;font-weight:700;padding:10px 14px;background:#f8fafc;text-align:left;border-bottom:2px solid #f0f2f7}
td{padding:13px 14px;border-bottom:1px solid #f8fafc;color:#334155;font-weight:500;vertical-align:middle}
tr:hover td{background:#fafbff}
tr:last-child td{border:none}
.badge{display:inline-flex;padding:4px 10px;border-radius:100px;font-size:11px;font-weight:700}
.b-paid{background:#dcfce7;color:#166534}
.b-unpaid{background:#fee2e2;color:#991b1b}
.empty{text-align:center;padding:48px;color:#94a3b8}
.empty .ei{font-size:40px;margin-bottom:12px}
@media(max-width:768px){.sidebar{display:none}.main{margin-left:0}.page{padding:16px}.summary-row{grid-template-columns:1fr 1fr}}
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sb-brand">
    <div class="bi">🏙️</div>
    <div><h4>SmartCity Portal</h4><small>Citizen Panel</small></div>
  </div>
  <div class="sb-nav">
    <div class="sb-label">Main</div>
    <a href="${pageContext.request.contextPath}/citizen/dashboard">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile">👤 My Profile</a>
    <div class="sb-label">City Services</div>
    <a href="${pageContext.request.contextPath}/citizen/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/citizen/complaints">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/citizen/bills" class="active">💡 Utility Bills</a>
    <a href="${pageContext.request.contextPath}/citizen/announcements">📢 Announcements</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="av" id="sidebarAv"><%= initial %></div>
      <div><div class="un"><%= user.getName() %></div><div class="ur">Citizen</div></div>
    </div>
    <a href="${pageContext.request.contextPath}/logout"><button class="logout-btn">🚪 Logout</button></a>
  </div>
</aside>
<div class="main">
  <div class="topbar">
    <div class="tb-left"><h3>💡 Utility Bills</h3><p>View and manage your city bills</p></div>
  </div>
  <div class="page">

    <div class="summary-row">
      <div class="sum-card sc-red"><div class="sum-val" style="color:#dc2626">₹<%= totalDue.setScale(0, java.math.RoundingMode.HALF_UP) %></div><div class="sum-lbl">Total Amount Due</div></div>
      <div class="sum-card sc-amber"><div class="sum-val" style="color:#d97706"><%= unpaidCount %></div><div class="sum-lbl">Unpaid Bills</div></div>
      <div class="sum-card sc-green"><div class="sum-val" style="color:#16a34a"><%= bills.size() - unpaidCount %></div><div class="sum-lbl">Bills Paid</div></div>
    </div>

    <% if (unpaidCount > 0) { %>
    <div class="bill-alert">
      <div class="bill-alert-icon">⚠️</div>
      <div class="bill-alert-text">
        <strong>You have <%= unpaidCount %> unpaid bill<%= unpaidCount>1?"s":"" %></strong>
        <span>Total outstanding amount: ₹<%= totalDue.setScale(2, java.math.RoundingMode.HALF_UP) %>. Please clear dues to avoid penalties.</span>
      </div>
    </div>
    <% } %>

    <div class="card">
      <div class="card-head">All Bills <span style="font-size:12px;color:#94a3b8;font-weight:500"><%= bills.size() %> records</span></div>
      <% if (bills.isEmpty()) { %>
        <div class="empty"><div class="ei">💡</div><p>No bills found for your account.</p></div>
      <% } else { %>
      <div style="overflow-x:auto">
      <table>
        <thead><tr><th>#ID</th><th>Type</th><th>Amount</th><th>Due Date</th><th>Status</th><th>Issued On</th></tr></thead>
        <tbody>
        <% for (Bill b : bills) { %>
          <tr>
            <td style="font-weight:700;color:#2563eb">#<%= b.getBillId() %></td>
            <td><span style="background:#f0f2f7;padding:3px 8px;border-radius:6px;font-size:11px;font-weight:700"><%= b.getType() %></span></td>
            <td style="font-weight:800;color:#0f172a">₹<%= b.getAmount() != null ? b.getAmount().setScale(2, java.math.RoundingMode.HALF_UP) : "0.00" %></td>
            <td style="color:<%= "Unpaid".equals(b.getStatus()) ? "#dc2626" : "#94a3b8" %>;font-weight:<%= "Unpaid".equals(b.getStatus()) ? "700" : "500" %>"><%= b.getDueDate() %></td>
            <td><span class="badge <%= "Paid".equals(b.getStatus()) ? "b-paid" : "b-unpaid" %>"><%= b.getStatus() %></span></td>
            <td style="color:#94a3b8;font-size:12px"><%= b.getIssuedAt() != null ? b.getIssuedAt().toString().substring(0,10) : "-" %></td>
          </tr>
        <% } %>
        </tbody>
      </table>
      </div>
      <% } %>
    </div>
  </div>
</div>
<script>
(function(){var p=localStorage.getItem('scp-photo');if(p){var a=document.getElementById('sidebarAv');if(a){a.style.background='none';a.innerHTML='<img src="'+p+'" style="width:100%;height:100%;object-fit:cover;border-radius:8px">';}}})();
</script>
</body>
</html>
