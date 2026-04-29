<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User,com.smartcity.model.Announcement,java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    if (announcements == null) announcements = new java.util.ArrayList<>();
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Announcements – Smart City Portal</title>
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
.page{padding:28px;max-width:820px}

/* CATEGORY FILTER */
.cat-tabs{display:flex;gap:8px;margin-bottom:22px;flex-wrap:wrap}
.cat-tab{padding:7px 16px;border-radius:100px;font-size:12px;font-weight:600;cursor:pointer;border:1px solid #e2e8f0;background:#fff;color:#64748b;transition:all .15s;font-family:inherit}
.cat-tab:hover{border-color:#2563eb;color:#2563eb}
.cat-tab.on{background:#2563eb;color:#fff;border-color:#2563eb;box-shadow:0 2px 8px rgba(37,99,235,.3)}

/* ANNOUNCEMENT CARDS */
.ann-card{background:#fff;border-radius:14px;border:1px solid #eef0f5;border-left:4px solid #e2e8f0;padding:20px 22px;margin-bottom:14px;box-shadow:0 1px 4px rgba(15,23,42,.03);transition:all .2s;position:relative;overflow:hidden}
.ann-card:hover{box-shadow:0 6px 20px rgba(15,23,42,.08);transform:translateY(-2px)}
.ann-card.cat-Alert{border-left-color:#ef4444}
.ann-card.cat-Event{border-left-color:#10b981}
.ann-card.cat-Maintenance{border-left-color:#f59e0b}
.ann-card.cat-General{border-left-color:#7c3aed}
.ann-meta{display:flex;align-items:center;gap:8px;margin-bottom:10px;flex-wrap:wrap}
.cat-badge{padding:3px 10px;border-radius:100px;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.4px}
.cb-alert{background:#fee2e2;color:#991b1b}
.cb-event{background:#dcfce7;color:#166534}
.cb-maintenance{background:#fef3c7;color:#92400e}
.cb-general{background:#ede9fe;color:#5b21b6}
.ann-date{font-size:11px;color:#94a3b8;font-weight:500}
.ann-author{font-size:11px;color:#94a3b8}
.ann-title{font-size:15px;font-weight:800;color:#0f172a;margin-bottom:6px;letter-spacing:-.2px}
.ann-body{font-size:13px;color:#475569;line-height:1.65}
.ann-icon{position:absolute;right:16px;top:16px;font-size:28px;opacity:.08}

.empty{text-align:center;padding:60px;color:#94a3b8}
.empty .ei{font-size:40px;margin-bottom:12px}

@keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
.ann-card{animation:fadeUp .3s ease both}

@media(max-width:768px){.sidebar{display:none}.main{margin-left:0}.page{padding:16px}}
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
    <a href="${pageContext.request.contextPath}/citizen/bills">💡 Utility Bills</a>
    <a href="${pageContext.request.contextPath}/citizen/announcements" class="active">📢 Announcements</a>
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
    <div class="tb-left"><h3>📢 City Announcements</h3><p>Official notices and updates from the municipality</p></div>
  </div>
  <div class="page">
    <div class="cat-tabs">
      <button class="cat-tab on" data-cat="all">All (<%= announcements.size() %>)</button>
      <button class="cat-tab" data-cat="Alert">🔴 Alerts</button>
      <button class="cat-tab" data-cat="Event">🟢 Events</button>
      <button class="cat-tab" data-cat="Maintenance">🟡 Maintenance</button>
      <button class="cat-tab" data-cat="General">🟣 General</button>
    </div>

    <% if (announcements.isEmpty()) { %>
      <div class="empty"><div class="ei">📭</div><p>No announcements at this time. Check back later!</p></div>
    <% } else {
         for (Announcement a : announcements) {
           String catCls = "cb-" + a.getCategory().toLowerCase();
           String annoIcon = "Alert".equals(a.getCategory()) ? "🚨" : "Event".equals(a.getCategory()) ? "🎉" : "Maintenance".equals(a.getCategory()) ? "🔧" : "📣";
    %>
      <div class="ann-card cat-<%= a.getCategory() %>" data-cat="<%= a.getCategory() %>">
        <div class="ann-icon"><%= annoIcon %></div>
        <div class="ann-meta">
          <span class="cat-badge <%= catCls %>"><%= a.getCategory() %></span>
          <span class="ann-date">🕐 <%= a.getCreatedAt() %></span>
          <% if (a.getPostedByName() != null) { %><span class="ann-author">· by <%= a.getPostedByName() %></span><% } %>
        </div>
        <div class="ann-title"><%= a.getTitle() %></div>
        <div class="ann-body"><%= a.getContent() %></div>
      </div>
    <% } } %>
  </div>
</div>
<script>
(function(){
  var photo=localStorage.getItem('scp-photo');
  if(photo){var av=document.getElementById('sidebarAv');if(av){av.style.background='none';av.innerHTML='<img src="'+photo+'" style="width:100%;height:100%;object-fit:cover;border-radius:8px">';}}
  document.querySelectorAll('.cat-tab').forEach(function(tab){
    tab.addEventListener('click',function(){
      document.querySelectorAll('.cat-tab').forEach(function(t){t.classList.remove('on');});
      tab.classList.add('on');
      var cat=tab.dataset.cat;
      document.querySelectorAll('.ann-card').forEach(function(card){
        card.style.display=(cat==='all'||card.dataset.cat===cat)?'':'none';
      });
    });
  });
})();
</script>
</body>
</html>
