<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User,com.smartcity.model.Complaint,java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    if (complaints == null) complaints = new java.util.ArrayList<>();
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>My Complaints – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/complaint-map.css">
  <script src="https://unpkg.com/lucide@latest"></script>
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
.btn-primary{display:inline-flex;align-items:center;gap:6px;padding:10px 20px;border-radius:9px;background:linear-gradient(135deg,#2563eb,#7c3aed);color:#fff;font-size:13px;font-weight:700;border:none;cursor:pointer;font-family:inherit;box-shadow:0 3px 10px rgba(37,99,235,.3);transition:all .15s}
.btn-primary:hover{box-shadow:0 6px 18px rgba(37,99,235,.4);transform:translateY(-1px);color:#fff}
.page{padding:28px}
.alert{padding:12px 16px;border-radius:10px;font-size:13px;font-weight:500;margin-bottom:18px;border-left:3px solid}
.alert-success{background:#f0fdf4;border-color:#16a34a;color:#065f46}
.alert-danger{background:#fef2f2;border-color:#dc2626;color:#991b1b}
.card{background:#fff;border-radius:14px;border:1px solid #eef0f5;padding:24px;box-shadow:0 1px 4px rgba(15,23,42,.04);margin-bottom:20px}
.card-head{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:18px;padding-bottom:14px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;justify-content:space-between}
.filter-row{display:flex;gap:8px;margin-bottom:18px;flex-wrap:wrap;align-items:center}
.fpill{padding:6px 14px;border-radius:100px;font-size:12px;font-weight:600;cursor:pointer;border:1px solid #e2e8f0;background:#fff;color:#64748b;transition:all .15s;font-family:inherit}
.fpill:hover{border-color:#2563eb;color:#2563eb}
.fpill.on{background:#eff6ff;border-color:#2563eb;color:#2563eb}
.fsearch{margin-left:auto;padding:8px 14px;border-radius:8px;border:1px solid #e2e8f0;font-size:13px;color:#0f172a;font-family:inherit;outline:none;background:#f8fafc;width:200px}
.fsearch:focus{border-color:#2563eb;box-shadow:0 0 0 3px rgba(37,99,235,.1)}
table{width:100%;border-collapse:collapse;font-size:13px}
th{font-size:11px;text-transform:uppercase;letter-spacing:.5px;color:#94a3b8;font-weight:700;padding:10px 14px;background:#f8fafc;text-align:left;border-bottom:2px solid #f0f2f7}
th:first-child{border-radius:8px 0 0 8px}th:last-child{border-radius:0 8px 8px 0}
td{padding:13px 14px;border-bottom:1px solid #f8fafc;color:#334155;font-weight:500;vertical-align:middle}
tr:hover td{background:#fafbff}
tr:last-child td{border:none}
.badge{display:inline-flex;padding:4px 10px;border-radius:100px;font-size:11px;font-weight:700;letter-spacing:.2px}
.b-pending{background:#fef3c7;color:#92400e}
.b-progress{background:#dbeafe;color:#1e40af}
.b-resolved{background:#dcfce7;color:#166534}
.empty{text-align:center;padding:48px 20px;color:#94a3b8}
.empty .ei{font-size:40px;margin-bottom:12px}
.empty p{font-size:14px;margin-bottom:16px}
@media(max-width:768px){.sidebar{display:none}.main{margin-left:0}.page{padding:16px}.fsearch{width:100%}}
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
    <a href="${pageContext.request.contextPath}/citizen/complaints" class="active">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/citizen/bills">💡 Utility Bills</a>
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
      <div class="tb-left"><h3>📋 My Complaints</h3><p>Track all your filed complaints</p></div>
      <div style="display:flex; gap:10px;">
        <button class="map-toggle-btn" id="toggleMap"><i data-lucide="map"></i> View on Map</button>
        <a href="${pageContext.request.contextPath}/citizen/new-complaint"><button class="btn-primary">+ New Complaint</button></a>
      </div>
    </div>
    <div class="page">
      <% if (request.getAttribute("success") != null) { %><div class="alert alert-success">✅ <%= request.getAttribute("success") %></div><% } %>
      <% if (request.getAttribute("error") != null) { %><div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div><% } %>
  
      <!-- Collapsible Map Panel -->
      <div class="map-collapse" id="mapSection">
        <div class="map-wrapper inline">
          <div id="inlineMap" style="background: #e5e7eb; height: 360px;"></div>
        </div>
      </div>

    <div class="card">
      <div class="card-head">All Complaints <span style="font-size:12px;color:#94a3b8;font-weight:500"><%= complaints.size() %> total</span></div>
      <div class="filter-row">
        <button class="fpill on" data-f="all">All</button>
        <button class="fpill" data-f="Pending">Pending</button>
        <button class="fpill" data-f="In Progress">In Progress</button>
        <button class="fpill" data-f="Resolved">Resolved</button>
        <input type="text" class="fsearch" id="csearch" placeholder="Search complaints...">
      </div>
      <% if (complaints.isEmpty()) { %>
        <div class="empty"><div class="ei">📋</div><p>No complaints filed yet.</p><a href="${pageContext.request.contextPath}/citizen/new-complaint"><button class="btn-primary">File Your First Complaint</button></a></div>
      <% } else { %>
      <div style="overflow-x:auto">
      <table id="ctable">
        <thead><tr><th>#ID</th><th>Category</th><th>Location</th><th>Description</th><th>Status</th><th>Date</th></tr></thead>
        <tbody>
        <% for (Complaint c : complaints) {
             String bCls = "Resolved".equals(c.getStatus()) ? "b-resolved" : "In Progress".equals(c.getStatus()) ? "b-progress" : "b-pending";
        %>
          <tr>
            <td style="font-weight:700;color:#2563eb">#<%= c.getComplaintId() %></td>
            <td><span style="background:#f0f2f7;padding:3px 8px;border-radius:6px;font-size:11px;font-weight:700"><%= c.getCategory() %></span></td>
            <td style="max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"><%= c.getLocation() %></td>
            <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#64748b"><%= c.getDescription() %></td>
            <td><span class="badge <%= bCls %>"><%= c.getStatus() %></span></td>
            <td style="color:#94a3b8;font-size:12px"><%= c.getDate() != null ? c.getDate().toString().substring(0,10) : "-" %></td>
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
(function(){
  var photo=localStorage.getItem('scp-photo');
  if(photo){var av=document.getElementById('sidebarAv');if(av){av.style.background='none';av.innerHTML='<img src="'+photo+'" style="width:100%;height:100%;object-fit:cover;border-radius:8px">'; }}
  // Filter pills
  document.querySelectorAll('.fpill').forEach(function(p){
    p.addEventListener('click',function(){
      document.querySelectorAll('.fpill').forEach(function(x){x.classList.remove('on');});
      p.classList.add('on');filterTable();
    });
  });
  var searchEl=document.getElementById('csearch');
  if(searchEl)searchEl.addEventListener('input',filterTable);
  function filterTable(){
    var f=(document.querySelector('.fpill.on')||{}).dataset.f||'all';
    var s=searchEl?searchEl.value.toLowerCase():'';
    var rows=document.querySelectorAll('#ctable tbody tr');
    rows.forEach(function(r){
      var text=r.textContent.toLowerCase();
      var statusMatch=f==='all'||text.includes(f.toLowerCase());
      var searchMatch=!s||text.includes(s);
      r.style.display=statusMatch&&searchMatch?'':'none';
    });
  }
})();
</script>
<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
/**
 * Inline Map Logic for Complaints List (Leaflet)
 */
(function() {
    let map, markers = [];
    const mapSection = document.getElementById('mapSection');
    const toggleBtn = document.getElementById('toggleMap');

    toggleBtn.addEventListener('click', () => {
        const isOpen = mapSection.classList.toggle('open');
        toggleBtn.classList.toggle('active');
        if (isOpen && !map) {
            initMap();
        }
    });

    function initMap() {
        map = L.map('inlineMap', { zoomControl: false }).setView([28.6139, 77.2090], 12);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(map);
        
        setTimeout(() => { map.invalidateSize(); }, 400);
        
        loadMarkers();
    }

    async function loadMarkers() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/citizen/map-data');
            const data = await response.json();
            const complaints = data.filter(c => c.latitude);
            
            const latlngs = [];
            
            complaints.forEach(c => {
                const pos = [parseFloat(c.latitude), parseFloat(c.longitude)];
                const marker = L.circleMarker(pos, {
                    radius: 7,
                    fillColor: c.status === 'Resolved' ? '#16a34a' : c.status === 'In Progress' ? '#d97706' : '#dc2626',
                    fillOpacity: 1,
                    color: '#fff',
                    weight: 2
                }).addTo(map);
                
                var popupHtml = '<div style="width:220px; padding:8px; font-family:Inter,sans-serif;">';
                if (c.imagePath) {
                    popupHtml += '<div style="width:100%; height:120px; margin-bottom:10px; border-radius:8px; overflow:hidden; background:#f1f5f9; border:1px solid #e2e8f0;">';
                    popupHtml += '<img src="${pageContext.request.contextPath}/' + c.imagePath + '" style="width:100%; height:100%; object-fit:cover;" onerror="this.parentElement.style.display=\'none\'">';
                    popupHtml += '</div>';
                }
                popupHtml += '<strong style="display:block; font-size:13px; color:#0f172a;">' + (c.category || '') + '</strong>';
                popupHtml += '<span style="font-size:11px; color:#64748b; display:block; margin:2px 0;">📍 ' + (c.location || '') + '</span>';
                popupHtml += '<div style="margin-top:6px;"><span style="display:inline-block; padding:2px 8px; border-radius:20px; font-size:10px; font-weight:700; background:' + (c.status === 'Resolved' ? '#dcfce7; color:#166534' : c.status === 'In Progress' ? '#fef3c7; color:#92400e' : '#fef2f2; color:#dc2626') + ';">' + (c.status || '') + '</span></div>';
                popupHtml += '</div>';
                
                marker.bindPopup(popupHtml);
                
                markers.push(marker);
                latlngs.push(pos);
            });
            
            if (latlngs.length > 0) map.fitBounds(L.latLngBounds(latlngs));
        } catch (e) { console.error(e); }
    }
    
    if (window.lucide) lucide.createIcons();
})();
</script>
</body>
</html>
