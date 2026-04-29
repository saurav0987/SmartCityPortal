<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User, com.smartcity.model.Complaint, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    if (complaints == null) complaints = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Complaints – Admin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/complaint-map.css">
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/lucide@latest"></script>
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
    <a href="${pageContext.request.contextPath}/admin/complaints" class="active">📋 Complaints</a>
    <a href="${pageContext.request.contextPath}/admin/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/admin/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/admin/bills">💡 Bills</a>
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
        <h2>📋 Manage Complaints</h2>
        <div class="sub">Review, update, and resolve citizen complaints</div>
      </div>
      <div style="display:flex; gap:12px; align-items:center;">
        <button class="map-toggle-btn" id="adminToggleMap"><i data-lucide="map"></i> Complaint Map</button>
        <div class="user-chip">
          <div class="avatar avatar-admin">A</div>
          <div>
            <div style="font-size:.8rem;font-weight:700;color:var(--text);"><%= admin.getName() %></div>
            <div style="font-size:.68rem;color:var(--muted);">Administrator</div>
          </div>
        </div>
      </div>
    </div>

  <div class="card reveal">
    <!-- Admin Map Panel -->
    <div class="map-collapse" id="adminMapSection">
      <div class="map-wrapper inline">
        <div id="adminInlineMap" style="background: #e5e7eb; height: 360px;"></div>
      </div>
    </div>

    <div class="section-header">
      <div class="card-title" style="margin:0;border:none;padding:0;">
        All Complaints
        <span class="badge badge-general" style="margin-left:.5rem;font-size:.68rem;"><%= complaints.size() %> total</span>
      </div>
    </div>
    <div class="filter-bar" style="margin-top:.75rem;">
      <button class="filter-pill active" data-filter="all">All</button>
      <button class="filter-pill" data-filter="pending">Pending</button>
      <button class="filter-pill" data-filter="in progress">In Progress</button>
      <button class="filter-pill" data-filter="resolved">Resolved</button>
      <input class="filter-search" placeholder="🔍 Search complaints...">
      <span class="filter-count"></span>
    </div>
    <div class="table-wrap" style="margin-top:1rem;">
      <table class="sc-table">
        <thead>
          <tr><th>#</th><th>Citizen</th><th>Category</th><th>Description</th><th>Location</th><th>Date</th><th>Status</th><th>Update</th></tr>
        </thead>
        <tbody>
          <% if (complaints.isEmpty()) { %>
            <tr><td colspan="8">
              <div class="empty-state">
                <div class="ei">📭</div>
                <p>No complaints filed yet.</p>
              </div>
            </td></tr>
          <% } else { for (Complaint c : complaints) {
               String sc = "Resolved".equals(c.getStatus())    ? "badge-resolved" :
                           "In Progress".equals(c.getStatus()) ? "badge-progress" : "badge-pending"; %>
            <tr>
              <td style="color:var(--muted);font-weight:600;">#<%= c.getComplaintId() %></td>
              <td><%= c.getUserName() != null ? c.getUserName() : "Citizen" %></td>
              <td><%= c.getCategory() %></td>
              <td style="max-width:200px;font-size:.79rem;color:var(--text-2);"><%= c.getDescription() %></td>
              <td style="color:var(--muted);"><%= c.getLocation() %></td>
              <td style="color:var(--muted);font-size:.79rem;"><%= c.getDate() %></td>
              <td><span class="badge <%= sc %>"><%= c.getStatus() %></span></td>
              <td>
                <form action="${pageContext.request.contextPath}/admin/update-complaint" method="post" style="display:flex;gap:.4rem;">
                  <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                  <select name="status" class="form-control" style="padding:.32rem .5rem;font-size:.78rem;width:130px;">
                    <option value="Pending"     <%= "Pending".equals(c.getStatus())     ? "selected" : "" %>>Pending</option>
                    <option value="In Progress" <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                    <option value="Resolved"    <%= "Resolved".equals(c.getStatus())    ? "selected" : "" %>>Resolved</option>
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
</div>
</main>

<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>
<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
/**
 * Admin Complaints Map Logic (Leaflet)
 */
(function() {
    let map, markers = [];
    const mapSection = document.getElementById('adminMapSection');
    const toggleBtn = document.getElementById('adminToggleMap');

    toggleBtn.addEventListener('click', () => {
        const isOpen = mapSection.classList.toggle('open');
        toggleBtn.classList.toggle('active');
        if (isOpen && !map) {
            initMap();
        }
    });

    function initMap() {
        map = L.map('adminInlineMap', { zoomControl: false }).setView([28.6139, 77.2090], 12);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(map);
        
        setTimeout(() => { map.invalidateSize(); }, 400);
        
        loadAllMarkers();
    }

    async function loadAllMarkers() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/admin/map-data');
            const complaints = await response.json();
            
            const latlngs = [];
            
            complaints.filter(c => c.latitude).forEach(c => {
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
                popupHtml += '<div style="font-size:10px; font-weight:800; color:#94a3b8; text-transform:uppercase;">' + (c.category || '') + '</div>';
                popupHtml += '<strong style="display:block; margin:4px 0; color:#0f172a;">' + (c.userName || 'Citizen') + '</strong>';
                popupHtml += '<p style="font-size:12px; color:#64748b; margin-bottom:8px;">' + (c.description || '').substring(0, 60) + '</p>';
                popupHtml += '<div style="font-size:11px; color:#64748b;">📍 ' + (c.location || '') + '</div>';
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
