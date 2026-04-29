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
  <title>File Complaint – Smart City Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/enhanced.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/complaint-map.css">
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <style>
    .form-hint {
      font-size: .72rem; color: var(--muted);
      margin-top: .28rem;
    }
    .category-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
      gap: .6rem; margin-bottom: .9rem;
    }
    .cat-option {
      display: none;
    }
    .cat-label {
      display: flex; flex-direction: column; align-items: center;
      gap: .4rem; padding: .85rem .6rem;
      background: var(--surface-2);
      border: 2px solid var(--border);
      border-radius: var(--r-md);
      cursor: pointer; font-size: .78rem; font-weight: 600;
      color: var(--text-2); text-align: center;
      transition: border-color var(--dur) ease, background var(--dur) ease, color var(--dur) ease;
    }
    .cat-label .cat-emoji { font-size: 1.5rem; }
    .cat-option:checked + .cat-label {
      border-color: var(--primary);
      background: var(--primary-light);
      color: var(--primary);
    }
    .cat-label:hover { border-color: var(--border-2); background: #fff; }
    .steps-indicator {
      display: flex; align-items: center; gap: .5rem;
      margin-bottom: 1.5rem; font-size: .78rem;
    }
    .step-dot {
      width: 26px; height: 26px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: .72rem; font-weight: 700;
      background: var(--primary); color: #fff;
      flex-shrink: 0;
    }
    .step-dot.done { background: var(--success); }
    .step-line { flex: 1; height: 2px; background: var(--border); }
    .step-text { color: var(--muted); font-size: .74rem; }
    .step-text.active { color: var(--text); font-weight: 600; }
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
    <a href="${pageContext.request.contextPath}/citizen/complaints" class="active">📋 My Complaints</a>
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
      <h2>📋 File a Complaint</h2>
      <div class="sub">Report any civic issue and we'll address it promptly</div>
    </div>
    <a href="${pageContext.request.contextPath}/citizen/complaints" class="btn btn-outline">← Back to Complaints</a>
  </div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="card reveal" style="max-width:640px;">
    <div class="card-title">Complaint Details</div>

    <form id="complaintForm" action="${pageContext.request.contextPath}/citizen/new-complaint" method="post">
      <input type="hidden" name="latitude" id="latField">
      <input type="hidden" name="longitude" id="lngField">
      <input type="hidden" name="imagePath" id="imagePathField">

      <!-- Category visual picker -->
      <div class="form-group">
        <label>Complaint Category *</label>
        <div class="category-grid">
          <div>
            <input type="radio" name="category" id="cat-road" value="Road" class="cat-option" required>
            <label for="cat-road" class="cat-label"><span class="cat-emoji">🛣️</span>Road</label>
          </div>
          <div>
            <input type="radio" name="category" id="cat-water" value="Water" class="cat-option">
            <label for="cat-water" class="cat-label"><span class="cat-emoji">💧</span>Water</label>
          </div>
          <div>
            <input type="radio" name="category" id="cat-electricity" value="Electricity" class="cat-option">
            <label for="cat-electricity" class="cat-label"><span class="cat-emoji">⚡</span>Electricity</label>
          </div>
          <div>
            <input type="radio" name="category" id="cat-garbage" value="Garbage" class="cat-option">
            <label for="cat-garbage" class="cat-label"><span class="cat-emoji">🗑️</span>Garbage</label>
          </div>
          <div>
            <input type="radio" name="category" id="cat-other" value="Other" class="cat-option">
            <label for="cat-other" class="cat-label"><span class="cat-emoji">📌</span>Other</label>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label for="location">Location *</label>
        <input type="text" id="location" name="location" class="form-control"
               required placeholder="e.g. MG Road, Near City Park, Block A">
        <div class="form-hint">Be as specific as possible to help us locate the issue.</div>
        <button type="button" class="geo-detect-btn btn btn-outline btn-sm" id="btnDetectLocation" style="margin-top:.4rem;">📍 Detect Location</button>
        
        <!-- Map Picker -->
        <div class="map-picker-section">
          <div class="map-picker-header">
            <h5><i data-lucide="map-pin" class="lucide-sm"></i> Select Exact Location on Map</h5>
            <div class="map-picker-coords" id="coordsDisplay">Not set</div>
          </div>
          <div id="locationPickerMap" style="background: #e5e7eb; height: 220px;"></div>
        </div>
      </div>

      <div class="form-group">
        <label for="description">Description *</label>
        <textarea id="description" name="description" class="form-control" rows="5"
                  required placeholder="Describe the issue in detail (what, when, how severe)..."></textarea>
        <div class="form-hint">A clear description helps us resolve the issue faster.</div>
      </div>

      <!-- File Upload -->
      <div class="form-group">
        <label>📎 Attach Photos (optional)</label>
        <div class="upload-zone" id="uploadZone">
          <div class="uz-icon">📷</div>
          <div class="uz-text">Drag & drop image here or click to browse</div>
          <div class="uz-hint">Supports JPG, PNG up to 5MB</div>
        </div>
        <input type="file" id="imageInput" accept="image/*" style="display:none">
        <div class="upload-progress" id="uploadProgressContainer" style="display:none">
          <div class="upload-progress-bar" id="uploadProgressBar"></div>
        </div>
        <div class="upload-previews" id="uploadPreviews"></div>
      </div>

      <div style="display:flex;gap:.75rem;margin-top:.25rem;">
        <button type="submit" class="btn btn-primary">Submit Complaint</button>
        <a href="${pageContext.request.contextPath}/citizen/complaints" class="btn btn-outline">Cancel</a>
      </div>
    </form>
  </div>

</div>
</main>

<div id="toast-container"></div>
<!-- Leaflet JS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/enhanced.js"></script>

<script>
/**
 * Interactive New Complaint Map Picker & Image Upload (Leaflet)
 */
(function() {
    let pickerMap, pickerMarker;
    const defaultLoc = [28.6139, 77.2090];

    window.addEventListener('load', () => {
        initPickerMap();
        initImageUpload();
        if (window.lucide) lucide.createIcons();
    });

    function initPickerMap() {
        pickerMap = L.map('locationPickerMap').setView(defaultLoc, 14);

        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(pickerMap);

        setTimeout(() => { pickerMap.invalidateSize(); }, 400);

        pickerMarker = L.marker(defaultLoc, { draggable: true });

        // Click on map to place marker
        pickerMap.on('click', (e) => {
            updateLocation(e.latlng);
        });

        // Drag marker to adjust location
        pickerMarker.on('dragend', (e) => {
            updateLocation(pickerMarker.getLatLng());
        });

        // Detect Location button
        document.getElementById('btnDetectLocation').addEventListener('click', () => {
            pickerMap.locate({setView: true, maxZoom: 16});
        });

        pickerMap.on('locationfound', (e) => {
            updateLocation(e.latlng);
        });
    }

    function updateLocation(latlng) {
        pickerMarker.setLatLng(latlng).addTo(pickerMap);
        
        document.getElementById('latField').value = latlng.lat;
        document.getElementById('lngField').value = latlng.lng;
        document.getElementById('coordsDisplay').innerText = 
            `Lat: ${latlng.lat.toFixed(4)}, Lng: ${latlng.lng.toFixed(4)}`;
        document.getElementById('coordsDisplay').classList.add('set');
        document.querySelector('.map-picker-section').classList.add('has-location');
    }

    function initImageUpload() {
        const zone = document.getElementById('uploadZone');
        const input = document.getElementById('imageInput');
        const preview = document.getElementById('uploadPreviews');
        const progContainer = document.getElementById('uploadProgressContainer');
        const progBar = document.getElementById('uploadProgressBar');
        const pathField = document.getElementById('imagePathField');
        let isPickerOpening = false;
        zone.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            if (isPickerOpening) return;
            
            isPickerOpening = true;
            input.click();
            
            // Release lock after 1 second
            setTimeout(() => { isPickerOpening = false; }, 1000);
        });

        zone.addEventListener('dragover', (e) => {
            e.preventDefault();
            zone.classList.add('dragover');
        });
        zone.addEventListener('dragleave', () => zone.classList.remove('dragover'));
        zone.addEventListener('drop', (e) => {
            e.preventDefault();
            zone.classList.remove('dragover');
            if (e.dataTransfer.files.length) handleUpload(e.dataTransfer.files[0]);
        });

        input.addEventListener('change', (e) => {
            if (input.files.length) handleUpload(input.files[0]);
        });

        function handleUpload(file) {
            if (!file.type.startsWith('image/')) {
                alert('Please upload an image file.');
                return;
            }

            const formData = new FormData();
            formData.append('image', file);

            progContainer.style.display = 'block';
            progBar.style.width = '0%';

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/citizen/upload-image', true);

            xhr.upload.onprogress = (e) => {
                if (e.lengthComputable) {
                    const percent = (e.loaded / e.total) * 100;
                    progBar.style.width = percent + '%';
                }
            };

            xhr.onload = function() {
                if (xhr.status === 200) {
                    const res = JSON.parse(xhr.responseText);
                    pathField.value = res.path;
                    
                    // Show preview
                    preview.innerHTML = `
                        <div class="upload-preview-item">
                            <img src="${pageContext.request.contextPath}/\${res.path}">
                            <div class="remove-preview" onclick="removeImage()">✕</div>
                        </div>
                    `;
                    zone.style.display = 'none';
                    progContainer.style.display = 'none';
                } else {
                    alert('Upload failed. Try again.');
                    progContainer.style.display = 'none';
                }
            };

            xhr.send(formData);
        }
    }

    window.removeImage = function() {
        document.getElementById('imagePathField').value = '';
        document.getElementById('uploadPreviews').innerHTML = '';
        document.getElementById('uploadZone').style.display = 'block';
        document.getElementById('imageInput').value = '';
    };
})();
</script>
</body>
</html>
