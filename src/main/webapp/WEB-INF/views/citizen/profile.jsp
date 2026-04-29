<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartcity.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String initial = String.valueOf(user.getName().charAt(0)).toUpperCase();
    String name = user.getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>My Profile – Smart City Portal</title>
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
.page{padding:28px;max-width:700px}

.profile-hero{background:linear-gradient(135deg,#1e40af 0%,#2563eb 55%,#7c3aed 100%);border-radius:18px;padding:32px;display:flex;align-items:center;gap:24px;margin-bottom:24px;position:relative;overflow:hidden}
.profile-hero::before{content:'';position:absolute;width:260px;height:260px;border-radius:50%;background:rgba(255,255,255,.06);top:-80px;right:-40px}
.photo-wrap{flex-shrink:0;text-align:center}
.photo-ring{width:88px;height:88px;border-radius:20px;border:3px solid rgba(255,255,255,.45);overflow:hidden;background:rgba(255,255,255,.18);display:flex;align-items:center;justify-content:center;font-size:34px;font-weight:900;color:#fff;cursor:pointer;position:relative;transition:all .2s}
.photo-ring:hover{border-color:rgba(255,255,255,.8)}
.photo-ring img{width:100%;height:100%;object-fit:cover}
.photo-ring .ov{position:absolute;inset:0;background:rgba(0,0,0,.45);display:flex;align-items:center;justify-content:center;opacity:0;transition:opacity .2s;border-radius:17px;font-size:22px}
.photo-ring:hover .ov{opacity:1}
.photo-hint{font-size:10px;color:rgba(255,255,255,.55);margin-top:6px;text-align:center}
.profile-info{flex:1;position:relative}
.profile-info h2{font-size:22px;font-weight:900;color:#fff;margin-bottom:4px;letter-spacing:-.3px}
.profile-info .email{font-size:13px;color:rgba(255,255,255,.7);margin-bottom:14px}
.pbadge{display:inline-flex;padding:4px 12px;border-radius:100px;font-size:11px;font-weight:700;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);color:#fff;margin-right:6px}

.card{background:#fff;border-radius:14px;border:1px solid #eef0f5;padding:24px;box-shadow:0 1px 4px rgba(15,23,42,.04);margin-bottom:18px}
.card-head{font-size:14px;font-weight:800;color:#0f172a;margin-bottom:18px;padding-bottom:14px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;gap:8px}
.info-row{display:flex;align-items:center;padding:12px 0;border-bottom:1px solid #f8fafc;font-size:13px}
.info-row:last-child{border:none;padding-bottom:0}
.info-lbl{width:150px;color:#94a3b8;font-weight:600;font-size:12px;flex-shrink:0}
.info-val{color:#0f172a;font-weight:600}
.badge-c{display:inline-flex;padding:3px 10px;border-radius:100px;background:#eff6ff;color:#2563eb;font-size:11px;font-weight:700}

/* PHOTO UPLOAD */
#photoInput{display:none}
.upload-zone{border:2px dashed #e2e8f0;border-radius:12px;padding:24px;text-align:center;cursor:pointer;transition:all .2s;background:#fafbff}
.upload-zone:hover{border-color:#2563eb;background:#eff6ff}
.uz-icon{font-size:36px;margin-bottom:8px}
.uz-text{font-size:13px;color:#64748b;font-weight:500;margin-bottom:4px}
.uz-hint{font-size:11px;color:#94a3b8}
.preview-area{display:none;text-align:center;margin-top:14px}
.preview-area img{width:80px;height:80px;object-fit:cover;border-radius:14px;border:2px solid #e2e8f0;box-shadow:0 4px 12px rgba(15,23,42,.1)}
.preview-area p{font-size:12px;color:#64748b;margin-top:6px}
.btn-row{display:flex;gap:10px;margin-top:14px;flex-wrap:wrap}
.btn-save{display:inline-flex;align-items:center;gap:6px;padding:10px 22px;border-radius:9px;background:linear-gradient(135deg,#2563eb,#7c3aed);color:#fff;font-size:13px;font-weight:700;border:none;cursor:pointer;font-family:inherit;box-shadow:0 3px 10px rgba(37,99,235,.3);transition:all .15s}
.btn-save:hover{box-shadow:0 6px 18px rgba(37,99,235,.4);transform:translateY(-1px)}
.btn-del{display:none;align-items:center;gap:6px;padding:10px 18px;border-radius:9px;background:#fff;color:#dc2626;font-size:13px;font-weight:700;border:1px solid #fecaca;cursor:pointer;font-family:inherit;transition:all .15s}
.btn-del:hover{background:#fef2f2}

.note-card{background:linear-gradient(135deg,#fffbeb,#fef9c3);border:1px solid #fde68a;border-radius:12px;padding:14px 18px;font-size:13px;color:#92400e;line-height:1.7}

@media(max-width:768px){.sidebar{display:none}.main{margin-left:0}.page{padding:16px}.profile-hero{flex-direction:column;text-align:center}.photo-wrap{align-self:center}}
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
    <a href="${pageContext.request.contextPath}/citizen/profile" class="active">👤 My Profile</a>
    <div class="sb-label">City Services</div>
    <a href="${pageContext.request.contextPath}/citizen/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/citizen/complaints">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/citizen/bills">💡 Utility Bills</a>
    <a href="${pageContext.request.contextPath}/citizen/announcements">📢 Announcements</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="av" id="sidebarAv"><%= initial %></div>
      <div><div class="un"><%= name %></div><div class="ur">Citizen</div></div>
    </div>
    <a href="${pageContext.request.contextPath}/logout"><button class="logout-btn">🚪 Logout</button></a>
  </div>
</aside>
<div class="main">
  <div class="topbar">
    <div class="tb-left"><h3>👤 My Profile</h3><p>Your account information</p></div>
  </div>
  <div class="page">
    <div class="profile-hero">
      <div class="photo-wrap">
        <div class="photo-ring" id="photoRing" onclick="document.getElementById('photoInput').click()">
          <span id="photoInitial"><%= initial %></span>
          <div class="ov">📷</div>
        </div>
        <div class="photo-hint">Click to change photo</div>
        <input type="file" id="photoInput" accept="image/*">
      </div>
      <div class="profile-info">
        <h2><%= name %></h2>
        <p class="email"><%= user.getEmail() %></p>
        <span class="pbadge">✅ Verified</span>
        <span class="pbadge">🏙️ Citizen</span>
      </div>
    </div>

    <div class="card">
      <div class="card-head">📋 Account Details</div>
      <div class="info-row"><span class="info-lbl">Full Name</span><span class="info-val"><%= name %></span></div>
      <div class="info-row"><span class="info-lbl">Email Address</span><span class="info-val"><%= user.getEmail() %></span></div>
      <div class="info-row"><span class="info-lbl">Phone Number</span><span class="info-val"><%= (user.getPhone()!=null&&!user.getPhone().isEmpty())?user.getPhone():"Not provided" %></span></div>
      <div class="info-row"><span class="info-lbl">Address</span><span class="info-val"><%= (user.getAddress()!=null&&!user.getAddress().isEmpty())?user.getAddress():"Not provided" %></span></div>
      <div class="info-row"><span class="info-lbl">Account Role</span><span class="info-val"><span class="badge-c"><%= user.getRole() %></span></span></div>
    </div>

    <div class="card">
      <div class="card-head">📷 Profile Photo</div>
      <div class="upload-zone" id="uploadZone" onclick="document.getElementById('photoInput').click()">
        <div class="uz-icon">🖼️</div>
        <div class="uz-text">Click to upload or change your photo</div>
        <div class="uz-hint">JPG, PNG, GIF — max 5MB</div>
      </div>
      <div class="preview-area" id="previewArea">
        <img id="previewImg" src="" alt="Preview">
        <p>Preview — click Save to apply</p>
      </div>
      <div class="btn-row">
        <button class="btn-save" onclick="savePhoto()">💾 Save Photo</button>
        <button class="btn-del" id="btnDel" onclick="removePhoto()">🗑️ Remove Photo</button>
      </div>
    </div>

    <div class="note-card">ℹ️ <strong>Note:</strong> To update your name, phone, or address details, please contact the city administration or call the municipal helpline. Profile photos are saved locally on this device.</div>
  </div>
</div>

<script>
(function(){
  var inp=document.getElementById('photoInput');
  var ring=document.getElementById('photoRing');
  var sav=document.getElementById('sidebarAv');
  var preArea=document.getElementById('previewArea');
  var preImg=document.getElementById('previewImg');
  var btnDel=document.getElementById('btnDel');
  var pending=null;
  var KEY='scp-photo';

  function setPhoto(src){
    ring.innerHTML='<img src="'+src+'" style="width:100%;height:100%;object-fit:cover"><div class="ov" onclick="document.getElementById(\'photoInput\').click()">📷</div>';
    if(sav){sav.style.background='none';sav.innerHTML='<img src="'+src+'" style="width:100%;height:100%;object-fit:cover;border-radius:8px">';}
    btnDel.style.display='inline-flex';
  }
  function clearPhoto(){
    ring.innerHTML='<span id="photoInitial"><%= initial %></span><div class="ov" onclick="document.getElementById(\'photoInput\').click()">📷</div>';
    if(sav){sav.style.background='';sav.innerHTML='<%= initial %>';}
    btnDel.style.display='none';
    preArea.style.display='none';
    pending=null;
  }
  window.savePhoto=function(){
    if(!pending){alert('Please select a photo first.');return;}
    localStorage.setItem(KEY,pending);
    setPhoto(pending);
    preArea.style.display='none';
    pending=null;
    showToast('Photo saved!');
  };
  window.removePhoto=function(){
    localStorage.removeItem(KEY);
    clearPhoto();
    showToast('Photo removed.');
  };
  function showToast(msg){
    var t=document.createElement('div');
    t.style.cssText='position:fixed;bottom:24px;right:24px;background:#0f172a;color:#fff;padding:12px 20px;border-radius:10px;font-size:13px;font-weight:600;font-family:Inter,sans-serif;z-index:9999;box-shadow:0 8px 24px rgba(0,0,0,.2);animation:fadeInUp .3s ease';
    t.textContent='✅ '+msg;
    document.body.appendChild(t);
    setTimeout(function(){t.remove();},2500);
  }
  inp.addEventListener('change',function(){
    var f=inp.files[0];
    if(!f)return;
    if(f.size>5*1024*1024){alert('File too large — max 5MB.');return;}
    var r=new FileReader();
    r.onload=function(e){
      pending=e.target.result;
      preImg.src=pending;
      preArea.style.display='block';
      setPhoto(pending);
    };
    r.readAsDataURL(f);
  });
  // Load saved on page load
  var saved=localStorage.getItem(KEY);
  if(saved){setPhoto(saved);}
})();
</script>
</body>
</html>
