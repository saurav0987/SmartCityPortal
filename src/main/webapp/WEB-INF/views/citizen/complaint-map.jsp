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
  <title>Complaint Map – Smart City Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  
  <!-- Leaflet CSS (Free Map) -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css" />
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/complaint-map.css">
  <script src="https://unpkg.com/lucide@latest"></script>
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
    <a href="${pageContext.request.contextPath}/citizen/complaint-map" class="active">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/citizen/complaints">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments">🏥 Appointments</a>
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
      <h2>📍 Interactive Complaint Map (Free Edition)</h2>
      <div class="sub">Explore and track civic issues across the city &mdash; Powered by OpenStreetMap</div>
    </div>
    <div class="topbar-actions">
      <a href="${pageContext.request.contextPath}/complaint?action=new" class="btn btn-primary">+ File Complaint</a>
    </div>
  </div>

  <div class="map-wrapper fullpage" style="position: relative;">
    <!-- Map Controls Overlay -->
    <div class="map-controls" style="z-index: 99999;">
      <div class="map-control-group">
        <button class="map-ctrl-btn" id="btnHeatmap">
          <span class="ctrl-icon">🔥</span> Heatmap <span class="ctrl-dot off" id="dotHeatmap"></span>
        </button>
        <button class="map-ctrl-btn" id="btnCluster">
          <span class="ctrl-icon">🧩</span> Clustering <span class="ctrl-dot off" id="dotCluster"></span>
        </button>
      </div>
      <div class="map-control-group">
        <button class="map-ctrl-btn" id="btnLocateMe">
          <span class="ctrl-icon">🎯</span> Find Me
        </button>
      </div>
    </div>

    <!-- Map Filter Bar Overlay -->
    <div class="map-filter-bar" style="z-index: 99999;">
      <button class="map-filter-pill active" data-filter="all">
        <span class="pill-dot pill-dot-all"></span> All <span class="pill-count" id="countAll">0</span>
      </button>
      <button class="map-filter-pill" data-filter="Pending">
        <span class="pill-dot pill-dot-pending"></span> Pending <span class="pill-count" id="countPending">0</span>
      </button>
      <button class="map-filter-pill" data-filter="In Progress">
        <span class="pill-dot pill-dot-progress"></span> In Progress <span class="pill-count" id="countProgress">0</span>
      </button>
      <button class="map-filter-pill" data-filter="Resolved">
        <span class="pill-dot pill-dot-resolved"></span> Resolved <span class="pill-count" id="countResolved">0</span>
      </button>
    </div>

    <!-- Map Element -->
    <div id="complaintMap" style="width:100%; height:100%;"></div>

    <!-- Legend Panel -->
    <div class="map-legend" style="z-index: 99999;">
      <h5>Map Legend</h5>
      <div class="legend-item"><span class="legend-marker legend-pending"></span> Pending Issue</div>
      <div class="legend-item"><span class="legend-marker legend-progress"></span> Work In Progress</div>
      <div class="legend-item"><span class="legend-marker legend-resolved"></span> Resolved / Fixed</div>
    </div>

    <!-- Stats Strip -->
    <div class="map-stats-strip" style="z-index: 99999;">
      <div class="map-stat-chip"><span class="stat-dot stat-dot-total"></span> <span id="statTotal">0</span> Complaints Total</div>
      <div class="map-stat-chip"><span class="stat-dot stat-dot-pending"></span> <span id="statPending">0</span> Pending</div>
      <div class="map-stat-chip"><span class="stat-dot stat-dot-resolved"></span> <span id="statResolved">0</span> Resolved</div>
    </div>
  </div>

</div>
</main>

<div id="toast-container"></div>

<!-- Leaflet JS (Free Map) -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"></script>
<script src="https://cdn.jsdelivr.net/npm/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
/**
 * Smart City Portal — Complaint Map Logic (Leaflet Edition)
 */
(function() {
    let map, heatmapLayer, markerClusterGroup;
    let allComplaints = [];
    let currentMarkers = [];
    let currentFilter = 'all';
    
    // Default center (Smart City Center)
    const defaultLocation = [28.6139, 77.2090];

    window.onload = function() {
        initMap();
        loadComplaintData();
        setupEventListeners();
        if (window.lucide) lucide.createIcons();
    };

    function initMap() {
        // Initialize Map
        map = L.map('complaintMap', {
            zoomControl: false
        }).setView(defaultLocation, 13);

        // Add OpenStreetMap Tile Layer
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(map);

        // Fix for maps not loading properly in some containers
        setTimeout(() => {
            map.invalidateSize();
        }, 400);

        // Move zoom control to bottom right
        L.control.zoom({ position: 'bottomright' }).addTo(map);

        // Initialize Marker Cluster Group
        markerClusterGroup = L.markerClusterGroup();
        map.addLayer(markerClusterGroup);

        // Initialize Heatmap Layer (not added to map yet — toggled via button)
        heatmapLayer = L.heatLayer([], {
            radius: 25,
            blur: 15,
            maxZoom: 17
        });
    }

    async function loadComplaintData() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/citizen/map-data');
            allComplaints = await response.json();
            
            updateStats();
            renderMarkers();
        } catch (error) {
            console.error('Error loading map data:', error);
            if (window.showToast) window.showToast('⚠️ Error loading map data', 'error');
        }
    }

    function updateStats() {
        const counts = { all: allComplaints.length, Pending: 0, 'In Progress': 0, Resolved: 0 };
        allComplaints.forEach(c => { if (counts[c.status] !== undefined) counts[c.status]++; });

        document.getElementById('countAll').innerText = counts.all;
        document.getElementById('countPending').innerText = counts.Pending;
        document.getElementById('countProgress').innerText = counts['In Progress'];
        document.getElementById('countResolved').innerText = counts.Resolved;
        
        document.getElementById('statTotal').innerText = counts.all;
        document.getElementById('statPending').innerText = counts.Pending;
        document.getElementById('statResolved').innerText = counts.Resolved;
    }

    function renderMarkers() {
        // Clear existing
        markerClusterGroup.clearLayers();
        currentMarkers.forEach(m => map.removeLayer(m));
        currentMarkers = [];

        const filtered = currentFilter === 'all' 
            ? allComplaints 
            : allComplaints.filter(c => c.status === currentFilter);

        const heatData = [];

        filtered.forEach(c => {
            if (!c.latitude || !c.longitude) return;

            const pos = [parseFloat(c.latitude), parseFloat(c.longitude)];
            heatData.push(pos);

            // Create a custom colored marker (Larger and more visible)
            const color = getStatusColor(c.status);
            const markerHtml = '<div style="background-color: ' + color + '; width: 18px; height: 18px; border-radius: 50%; border: 2px solid #fff; box-shadow: 0 0 8px rgba(0,0,0,0.3);"></div>';
            
            const marker = L.marker(pos, {
                icon: L.divIcon({
                    html: markerHtml,
                    className: '',
                    iconSize: [20, 20],
                    iconAnchor: [10, 10]
                })
            });

            // Bind Popup with safe HTML construction
            var popupHtml = '<div style="width:240px; min-height:100px; padding:10px; font-family:sans-serif;">';
            if (c.imagePath) {
                const imgUrl = '${pageContext.request.contextPath}/' + c.imagePath;
                popupHtml += '<div style="width:100%; height:140px; margin-bottom:12px; border-radius:8px; overflow:hidden; background:#f1f5f9; border:1px solid #e2e8f0;">';
                popupHtml += '<img src="' + imgUrl + '" style="width:100%; height:100%; object-fit:cover;" onerror="this.parentElement.style.display=\'none\'">';
                popupHtml += '</div>';
            }
            popupHtml += '<div style="font-size:10px; color:#94a3b8; text-transform:uppercase; font-weight:700; letter-spacing:0.5px;">' + (c.category || '') + '</div>';
            popupHtml += '<div style="font-size:14px; font-weight:bold; margin:6px 0; color:#0f172a;">' + (c.description || 'No description') + '</div>';
            popupHtml += '<div style="font-size:12px; margin:4px 0;"><span style="display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:700; background:' + (c.status === 'Resolved' ? '#dcfce7; color:#166534' : c.status === 'In Progress' ? '#fef3c7; color:#92400e' : '#fef2f2; color:#dc2626') + ';">' + (c.status || '') + '</span></div>';
            popupHtml += '<div style="font-size:11px; color:#64748b; margin-top:6px;">📍 ' + (c.location || '') + '</div>';
            if (c.userName) popupHtml += '<div style="font-size:10px; color:#94a3b8; margin-top:4px;">👤 ' + c.userName + '</div>';
            popupHtml += '</div>';
            marker.bindPopup(popupHtml);

            if (document.getElementById('dotCluster').classList.contains('on')) {
                markerClusterGroup.addLayer(marker);
            } else {
                marker.addTo(map);
            }
            currentMarkers.push(marker);
        });

        heatmapLayer.setLatLngs(heatData);

        // Automatically zoom map to show all markers
        if (heatData.length > 0) {
            map.fitBounds(L.latLngBounds(heatData), { padding: [50, 50] });
        }
    }

    function getStatusColor(status) {
        if (status === 'Pending') return '#dc2626';
        if (status === 'In Progress') return '#d97706';
        if (status === 'Resolved') return '#16a34a';
        return '#2563eb';
    }

    function setupEventListeners() {
        // Filter Pills
        document.querySelectorAll('.map-filter-pill').forEach(pill => {
            pill.addEventListener('click', () => {
                document.querySelectorAll('.map-filter-pill').forEach(p => p.classList.remove('active'));
                pill.classList.add('active');
                currentFilter = pill.dataset.filter;
                renderMarkers();
            });
        });

        // Heatmap Toggle
        document.getElementById('btnHeatmap').addEventListener('click', function() {
            const dot = document.getElementById('dotHeatmap');
            const isActive = dot.classList.contains('on');
            
            if (isActive) {
                dot.classList.replace('on', 'off');
                map.removeLayer(heatmapLayer);
                this.classList.remove('active');
            } else {
                dot.classList.replace('off', 'on');
                heatmapLayer.addTo(map);
                this.classList.add('active');
            }
        });

        // Clustering Toggle
        document.getElementById('btnCluster').addEventListener('click', function() {
            const dot = document.getElementById('dotCluster');
            const isActive = dot.classList.contains('on');
            
            if (isActive) {
                dot.classList.replace('on', 'off');
                this.classList.remove('active');
            } else {
                dot.classList.replace('off', 'on');
                this.classList.add('active');
            }
            renderMarkers(); // Re-render with/without cluster group
        });

        // Locate Me
        document.getElementById('btnLocateMe').addEventListener('click', function() {
            map.locate({setView: true, maxZoom: 16});
        });

        map.on('locationfound', function(e) {
            L.circle(e.latlng, e.accuracy).addTo(map);
            L.marker(e.latlng).addTo(map).bindPopup("You are here").openPopup();
        });

        map.on('locationerror', function(e) {
            if (window.showToast) window.showToast('Unable to detect location', 'warning');
        });
    }

})();
</script>
</body>
</html>
