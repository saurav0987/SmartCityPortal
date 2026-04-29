<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="user" value="${sessionScope.loggedUser}" />
<c:if test="${empty user}">
    <c:redirect url="/login" />
</c:if>
<c:set var="initial" value="${fn:toUpperCase(fn:substring(user.name, 0, 1))}" />
<c:set var="name" value="${user.name}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Dashboard – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-premium.css">
  <style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',-apple-system,sans-serif;background:#f4f6fb;color:#0f172a;-webkit-font-smoothing:antialiased;display:flex;min-height:100vh}
a{text-decoration:none;color:inherit}

/* SIDEBAR */
.sidebar{width:240px;background:#fff;border-right:1px solid #eef0f5;display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:200;transition:transform .3s ease}
.sb-brand{padding:20px 18px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;gap:10px}
.sb-brand .bi{width:38px;height:38px;border-radius:10px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 4px 10px rgba(37,99,235,.3)}
.sb-brand h4{font-size:13px;font-weight:800;color:#0f172a;line-height:1.3}
.sb-brand small{font-size:10px;color:#94a3b8;font-weight:500}
.sb-nav{flex:1;padding:12px 0;overflow-y:auto}
.sb-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.7px;color:#94a3b8;padding:10px 18px 4px}
.sb-nav a{display:flex;align-items:center;gap:10px;padding:9px 18px;font-size:13px;font-weight:500;color:#64748b;border-left:2px solid transparent;transition:all .15s}
.sb-nav a:hover{color:#0f172a;background:#f8fafc}
.sb-nav a.active{color:#2563eb;background:linear-gradient(90deg,#eff6ff,#f8fafc);border-left-color:#2563eb;font-weight:600}
.sb-foot{padding:14px 16px;border-top:1px solid #f0f2f7}
.sb-user{display:flex;align-items:center;gap:10px;padding:10px 12px;background:#f8fafc;border-radius:10px;margin-bottom:10px}
.sb-user .av{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;color:#fff;font-size:12px;font-weight:800;flex-shrink:0}
.sb-user .un{font-size:12px;font-weight:700;color:#0f172a}
.sb-user .ur{font-size:10px;color:#94a3b8}
.logout-btn{display:flex;align-items:center;justify-content:center;width:100%;padding:9px;border-radius:8px;border:1px solid #e8eaf0;background:#fff;font-size:12px;font-weight:600;color:#64748b;cursor:pointer;font-family:inherit;transition:all .15s}
.logout-btn:hover{background:#fef2f2;color:#dc2626;border-color:#fecaca}

/* MAIN */
.main{margin-left:240px;flex:1;min-height:100vh}

/* TOPBAR */
.topbar{background:rgba(255,255,255,.95);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border-bottom:1px solid #eef0f5;padding:0 28px;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;box-shadow:0 1px 3px rgba(15,23,42,.04)}
.tb-left h3{font-size:18px;font-weight:800;color:#0f172a;letter-spacing:-.3px}
.tb-left p{font-size:12px;color:#94a3b8;margin-top:1px}
.tb-right{display:flex;align-items:center;gap:10px}
.tb-chip{display:flex;align-items:center;gap:8px;padding:7px 12px;background:#f8fafc;border:1px solid #eef0f5;border-radius:10px;cursor:pointer;transition:all .25s ease}
.tb-chip:hover{background:#f1f5f9;box-shadow:0 2px 8px rgba(15,23,42,.08)}
.tb-chip .av{width:28px;height:28px;border-radius:7px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;color:#fff;font-size:11px;font-weight:800}
.tb-chip .tn{font-size:12px;font-weight:700;color:#0f172a}
.notif-wrap{position:relative}
.notif-bell{width:38px;height:38px;border-radius:10px;background:#f1f5f9;border:1px solid #e2e8f0;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1rem;position:relative;transition:all .25s ease}
.notif-bell:hover{border-color:#2563eb;background:#eff6ff;transform:scale(1.05)}
.notif-badge{position:absolute;top:-4px;right:-4px;min-width:17px;height:17px;border-radius:9px;background:#dc2626;color:#fff;font-size:9px;font-weight:800;display:flex;align-items:center;justify-content:center;padding:0 4px;border:2px solid #fff}
.notif-dropdown{position:absolute;top:calc(100% + 8px);right:0;width:340px;max-height:400px;overflow-y:auto;background:#fff;border:1px solid #e2e8f0;border-radius:16px;box-shadow:0 20px 60px rgba(15,23,42,.16);z-index:500;display:none}
.notif-dropdown.open{display:block;animation:ddIn .2s ease both}
@keyframes ddIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
.notif-header{padding:14px 16px;border-bottom:1px solid #f0f2f7;font-size:13px;font-weight:800;color:#0f172a;display:flex;justify-content:space-between;align-items:center}
.notif-clear{background:none;border:none;color:#2563eb;cursor:pointer;font-size:11px;font-weight:600;font-family:inherit}
.notif-item{padding:12px 16px;border-bottom:1px solid #f8fafc;display:flex;gap:10px;align-items:flex-start;transition:background .15s}
.notif-item:hover{background:#f8fafc}
.notif-icon{width:34px;height:34px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0}
.ni-info{background:#f0f9ff}.ni-success{background:#f0fdf4}.ni-warning{background:#fffbeb}
.notif-text{font-size:12px;color:#334155;line-height:1.5}.notif-text strong{color:#2563eb}
.notif-time{font-size:10px;color:#94a3b8;margin-top:3px}
.notif-empty{padding:32px;text-align:center;color:#94a3b8;font-size:13px}
.avatar-dropdown{position:absolute;top:calc(100% + 8px);right:0;width:220px;background:#fff;border:1px solid #e2e8f0;border-radius:14px;box-shadow:0 16px 48px rgba(15,23,42,.14);z-index:500;display:none;overflow:hidden}
.avatar-dropdown.open{display:block;animation:ddIn .2s ease both}
.avd-header{padding:16px;border-bottom:1px solid #f0f2f7;display:flex;align-items:center;gap:10px}
.avd-name{font-size:13px;font-weight:700;color:#0f172a}.avd-role{font-size:10px;color:#94a3b8}
.avd-item{display:flex;align-items:center;gap:10px;padding:10px 16px;font-size:13px;color:#334155;transition:background .15s;cursor:pointer;text-decoration:none}
.avd-item:hover{background:#f8fafc;color:#0f172a}
.avd-item.danger{color:#dc2626}.avd-item.danger:hover{background:#fef2f2}
.avd-divider{height:1px;background:#f0f2f7;margin:2px 0}
.icon-box{width:44px;height:44px;border-radius:12px;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;transition:transform .3s ease}
.icon-box-blue{background:#eff6ff;color:#2563eb}.icon-box-green{background:#f0fdf4;color:#16a34a}.icon-box-amber{background:#fffbeb;color:#d97706}.icon-box-purple{background:#f5f3ff;color:#7c3aed}.icon-box-red{background:#fef2f2;color:#dc2626}

/* PAGE CONTENT */
.page{padding:28px}

/* WELCOME BANNER */
.welcome{background:linear-gradient(135deg,#1e40af 0%,#2563eb 50%,#7c3aed 100%);border-radius:16px;padding:28px 32px;display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;position:relative;overflow:hidden}
.welcome::before{content:'';position:absolute;width:300px;height:300px;border-radius:50%;background:rgba(255,255,255,.05);top:-100px;right:-50px;pointer-events:none}
.welcome::after{content:'';position:absolute;width:200px;height:200px;border-radius:50%;background:rgba(255,255,255,.04);bottom:-80px;right:150px;pointer-events:none}
.welcome h2{font-size:22px;font-weight:900;color:#fff;margin-bottom:6px;position:relative}
.welcome p{font-size:13px;color:rgba(255,255,255,.78);position:relative}
.welcome-actions{display:flex;gap:10px;position:relative}
.wb-btn{padding:10px 20px;border-radius:8px;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;border:none;transition:all .15s}
.wb-btn-primary{background:#fff;color:#2563eb}
.wb-btn-primary:hover{box-shadow:0 4px 12px rgba(255,255,255,.3);transform:translateY(-1px)}
.wb-btn-outline{background:rgba(255,255,255,.12);color:#fff;border:1px solid rgba(255,255,255,.3)}
.wb-btn-outline:hover{background:rgba(255,255,255,.2)}

/* STAT CARDS */
.stats-row{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px;margin-bottom:24px}
.stat-card{background:#fff;border-radius:14px;padding:20px;border:1px solid #eef0f5;box-shadow:0 1px 4px rgba(15,23,42,.04);transition:all .2s;position:relative;overflow:hidden}
.stat-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;border-radius:0 0 0 0;opacity:0;transition:opacity .2s}
.stat-card:hover{transform:translateY(-3px);box-shadow:0 8px 24px rgba(15,23,42,.08)}
.stat-card:hover::before{opacity:1}
.sc-1::before{background:linear-gradient(90deg,#2563eb,#60a5fa)}
.sc-2::before{background:linear-gradient(90deg,#16a34a,#4ade80)}
.sc-3::before{background:linear-gradient(90deg,#d97706,#fbbf24)}
.sc-4::before{background:linear-gradient(90deg,#dc2626,#f87171)}
.sc-5::before{background:linear-gradient(90deg,#7c3aed,#a78bfa)}
.sc-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;margin-bottom:14px}
.sc-val{font-size:28px;font-weight:900;color:#0f172a;letter-spacing:-1px;line-height:1}
.sc-lbl{font-size:12px;color:#64748b;margin-top:4px;font-weight:500}
.sc-link{font-size:11px;color:#2563eb;margin-top:10px;display:inline-flex;align-items:center;gap:3px;font-weight:600}
.sc-link:hover{color:#1d4ed8}

/* QUICK ACTIONS */
.section-title{font-size:15px;font-weight:800;color:#0f172a;margin-bottom:16px;letter-spacing:-.2px;display:flex;align-items:center;gap:8px}
.qa-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;margin-bottom:28px}
.qa-card{background:#fff;border-radius:16px;padding:0;border:1px solid #eef0f5;transition:all .3s ease;cursor:pointer;position:relative;overflow:hidden}
.qa-card::after{content:'';position:absolute;top:0;left:0;right:0;height:4px;border-radius:16px 16px 0 0;z-index:1}
.qa-card:hover{transform:translateY(-5px);box-shadow:0 16px 40px rgba(15,23,42,.13);border-color:#c7d2fe}
.qa-c1::after{background:linear-gradient(90deg,#3b82f6,#60a5fa)}
.qa-c2::after{background:linear-gradient(90deg,#8b5cf6,#a78bfa)}
.qa-c3::after{background:linear-gradient(90deg,#16a34a,#4ade80)}
.qa-c4::after{background:linear-gradient(90deg,#d97706,#fbbf24)}
.qa-c5::after{background:linear-gradient(90deg,#7c3aed,#c084fc)}
.qa-img{width:100%;height:120px;overflow:hidden;position:relative}
.qa-img img{width:100%;height:100%;object-fit:cover;transition:transform .45s ease,filter .3s ease}
.qa-img::before{content:'';position:absolute;inset:0;background:linear-gradient(to top,rgba(15,23,42,.03),transparent);pointer-events:none;z-index:1;transition:background .3s ease}
.qa-card:hover .qa-img img{transform:scale(1.08);filter:brightness(1.05)}
.qa-body{padding:18px 20px}
.qa-title{font-size:14px;font-weight:700;color:#0f172a;margin-bottom:4px}
.qa-desc{font-size:12px;color:#64748b;line-height:1.5;margin-bottom:12px}
.qa-act{font-size:11px;color:#2563eb;font-weight:600;display:flex;align-items:center;gap:3px}

/* ACCOUNT CARD */
.info-card{background:#fff;border-radius:14px;border:1px solid #eef0f5;padding:24px;box-shadow:0 1px 4px rgba(15,23,42,.04)}
.info-row{display:flex;padding:11px 0;border-bottom:1px solid #f8fafc;font-size:13px;align-items:center}
.info-row:last-child{border:none}
.info-lbl{width:140px;color:#94a3b8;font-weight:600;font-size:12px;flex-shrink:0}
.info-val{color:#0f172a;font-weight:600}
.badge-citizen{display:inline-flex;padding:3px 10px;border-radius:100px;background:#eff6ff;color:#2563eb;font-size:11px;font-weight:700}

@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.fade-in{animation:fadeUp .4s ease both}

@media(max-width:768px){.sidebar{transform:translateX(-100%)}.sidebar.open{transform:translateX(0)}.main{margin-left:0}.page{padding:16px}.stats-row{grid-template-columns:1fr 1fr}.qa-grid{grid-template-columns:1fr 1fr}.welcome{flex-direction:column;gap:16px}}
  </style>
</head>
<body>

<aside class="sidebar" id="sidebar">
  <div class="sb-brand">
    <div class="bi">🏙️</div>
    <div><h4>SmartCity Portal</h4><small>Citizen Panel</small></div>
  </div>
  <div class="sb-nav">
    <div class="sb-label">Main</div>
    <a href="${pageContext.request.contextPath}/citizen/dashboard" class="active">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/citizen/profile">👤 My Profile</a>
    <div class="sb-label">City Services</div>
    <a href="${pageContext.request.contextPath}/citizen/complaint-map">📍 Complaint Map</a>
    <a href="${pageContext.request.contextPath}/citizen/complaints">📋 My Complaints</a>
    <a href="${pageContext.request.contextPath}/citizen/appointments">🏥 Appointments</a>
    <a href="${pageContext.request.contextPath}/citizen/bills">💡 Utility Bills</a>
    <a href="${pageContext.request.contextPath}/citizen/announcements">📢 Announcements</a>
  </div>
  <div class="sb-foot">
    <div class="sb-user">
      <div class="av" id="sidebarAv">${initial}</div>
      <div><div class="un">${name}</div><div class="ur">Citizen</div></div>
    </div>
    <a href="${pageContext.request.contextPath}/logout"><button class="logout-btn">🚪 Logout</button></a>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <div class="tb-left">
      <h3>Dashboard</h3>
      <p>Hello, ${name} — here's your overview</p>
    </div>
    <div class="tb-right">
      <div class="notif-wrap">
        <button class="notif-bell" data-tooltip="Notifications"><i data-lucide="bell" style="width:18px;height:18px"></i><span class="notif-badge">3</span></button>
        <div class="notif-dropdown"><div class="notif-header"><span>Notifications</span><button class="notif-clear">Clear all</button></div><div class="notif-list"></div></div>
      </div>
      <div class="tb-chip" id="avatarChip" style="position:relative">
        <div class="av">${initial}</div>
        <div><div class="tn">${name}</div></div>
        <div class="avatar-dropdown" id="avatarDD">
          <div class="avd-header"><div class="av" style="width:36px;height:36px;border-radius:10px;font-size:14px">${initial}</div><div><div class="avd-name">${name}</div><div class="avd-role">Citizen Account</div></div></div>
          <a href="${pageContext.request.contextPath}/citizen/profile" class="avd-item"><i data-lucide="user" class="lucide-sm"></i> My Profile</a>
          <a href="${pageContext.request.contextPath}/citizen/dashboard" class="avd-item"><i data-lucide="layout-dashboard" class="lucide-sm"></i> Dashboard</a>
          <div class="avd-divider"></div>
          <a href="${pageContext.request.contextPath}/logout" class="avd-item danger"><i data-lucide="log-out" class="lucide-sm"></i> Logout</a>
        </div>
      </div>
    </div>
  </div>

  <div class="page">

    <!-- Welcome banner -->
    <div class="welcome fade-in">
      <div>
        <h2>Welcome back, ${name}! 👋</h2>
        <p>Use the quick actions below to access city services instantly.</p>
      </div>
      <div class="welcome-actions">
        <a href="${pageContext.request.contextPath}/citizen/new-complaint"><button class="wb-btn wb-btn-primary">+ File Complaint</button></a>
        <a href="${pageContext.request.contextPath}/citizen/book-appointment"><button class="wb-btn wb-btn-outline">Book Appointment</button></a>
      </div>
    </div>

    <!-- Stat cards -->
    <div class="stats-row">
      <div class="stat-card sc-1 fade-in">
        <div class="sc-icon" style="background:#eff6ff">📋</div>
        <div class="sc-val" id="statComplaints">${complaintCount}</div>
        <div class="sc-lbl">My Complaints</div>
        <a href="${pageContext.request.contextPath}/citizen/complaints" class="sc-link">View all →</a>
      </div>
      <div class="stat-card sc-2 fade-in" style="animation-delay:.05s">
        <div class="sc-icon" style="background:#f0fdf4">🏥</div>
        <div class="sc-val" id="statAppts">${appointmentCount}</div>
        <div class="sc-lbl">Appointments</div>
        <a href="${pageContext.request.contextPath}/citizen/appointments" class="sc-link">View all →</a>
      </div>
      <div class="stat-card sc-3 fade-in" style="animation-delay:.1s">
        <div class="sc-icon" style="background:#fffbeb">💡</div>
        <div class="sc-val" id="statBills">${billCount}</div>
        <div class="sc-lbl">Pending Bills</div>
        <a href="${pageContext.request.contextPath}/citizen/bills" class="sc-link">Pay now →</a>
      </div>
      <div class="stat-card sc-4 fade-in" style="animation-delay:.15s">
        <div class="sc-icon" style="background:#fef2f2">📢</div>
        <div class="sc-val">Live</div>
        <div class="sc-lbl">Announcements</div>
        <a href="${pageContext.request.contextPath}/citizen/announcements" class="sc-link">Read →</a>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="section-title">⚡ Quick Actions</div>
    <div class="qa-grid">
      <a href="${pageContext.request.contextPath}/citizen/new-complaint"><div class="qa-card qa-c1 animate-in">
        <div class="qa-img"><img src="${pageContext.request.contextPath}/images/card-complaints.png" alt="File Complaint"></div>
        <div class="qa-body">
          <div class="icon-box icon-box-blue" style="margin-bottom:10px"><i data-lucide="clipboard-list"></i></div>
          <div class="qa-title">File Complaint</div>
          <div class="qa-desc">Road, Water, Electricity, Garbage issues</div>
          <div class="qa-act">Report now →</div>
        </div>
      </div></a>
      <a href="${pageContext.request.contextPath}/citizen/complaints"><div class="qa-card qa-c2 animate-in">
        <div class="qa-img"><img src="${pageContext.request.contextPath}/images/card-complaints.png" alt="Track Complaints" style="filter:hue-rotate(40deg)"></div>
        <div class="qa-body">
          <div class="icon-box icon-box-purple" style="margin-bottom:10px"><i data-lucide="search"></i></div>
          <div class="qa-title">My Complaints</div>
          <div class="qa-desc">View status updates on filed complaints</div>
          <div class="qa-act">View list →</div>
        </div>
      </div></a>
      <a href="${pageContext.request.contextPath}/citizen/book-appointment"><div class="qa-card qa-c3 animate-in">
        <div class="qa-img"><img src="${pageContext.request.contextPath}/images/card-appointments.png" alt="Book Appointment"></div>
        <div class="qa-body">
          <div class="icon-box icon-box-green" style="margin-bottom:10px"><i data-lucide="calendar-plus"></i></div>
          <div class="qa-title">Book Appointment</div>
          <div class="qa-desc">City hospital doctors & consultations</div>
          <div class="qa-act">Book now →</div>
        </div>
      </div></a>
      <a href="${pageContext.request.contextPath}/citizen/bills"><div class="qa-card qa-c4 animate-in">
        <div class="qa-img"><img src="${pageContext.request.contextPath}/images/card-bills.png" alt="Utility Bills"></div>
        <div class="qa-body">
          <div class="icon-box icon-box-amber" style="margin-bottom:10px"><i data-lucide="receipt"></i></div>
          <div class="qa-title">Utility Bills</div>
          <div class="qa-desc">View & pay pending bills online</div>
          <div class="qa-act">Open bills →</div>
        </div>
      </div></a>
      <a href="${pageContext.request.contextPath}/citizen/announcements"><div class="qa-card qa-c5 animate-in">
        <div class="qa-img"><img src="${pageContext.request.contextPath}/images/card-announcements.png" alt="Announcements"></div>
        <div class="qa-body">
          <div class="icon-box icon-box-purple" style="margin-bottom:10px"><i data-lucide="megaphone"></i></div>
          <div class="qa-title">City Notices</div>
          <div class="qa-desc">Official announcements from municipality</div>
          <div class="qa-act">Read →</div>
        </div>
      </div></a>
    </div>

    <!-- Account Details -->
    <div class="section-title">📋 Account Details</div>
    <div class="info-card fade-in" style="max-width:500px">
      <div class="info-row"><span class="info-lbl">Full Name</span><span class="info-val">${user.name}</span></div>
      <div class="info-row"><span class="info-lbl">Email</span><span class="info-val">${user.email}</span></div>
      <div class="info-row"><span class="info-lbl">Phone</span><span class="info-val">${not empty user.phone ? user.phone : 'Not provided'}</span></div>
      <div class="info-row"><span class="info-lbl">Role</span><span class="info-val"><span class="badge-citizen">${user.role}</span></span></div>
    </div>

  </div>
</div>

<script>
// Count up stat numbers from DB (table-driven, just animate from 0)
(function(){
  document.querySelectorAll('.sc-val').forEach(function(el){
    var n=parseInt(el.textContent);
    if(isNaN(n))return;
    var start=0;var dur=800;var step=Math.ceil(n/20)||1;
    var t=setInterval(function(){start=Math.min(start+step,n);el.textContent=start;if(start>=n)clearInterval(t);},dur/20);
  });
  // Load profile photo from localStorage if available
  var photo=localStorage.getItem('scp-photo');
  if(photo){
    var av=document.getElementById('sidebarAv');
    if(av){av.style.background='none';av.innerHTML='<img src="'+photo+'" style="width:100%;height:100%;object-fit:cover;border-radius:8px">';}
  }
})();

// Initialize Lucide icons
if(window.lucide) lucide.createIcons();

// Notification bell toggle
document.addEventListener('click',function(e){
  var bell=e.target.closest('.notif-bell');
  if(bell){var dd=bell.closest('.notif-wrap').querySelector('.notif-dropdown');dd.classList.toggle('open');e.stopPropagation();return;}
  if(!e.target.closest('.notif-dropdown'))document.querySelectorAll('.notif-dropdown.open').forEach(function(d){d.classList.remove('open');});
  var clr=e.target.closest('.notif-clear');
  if(clr){var dd=clr.closest('.notif-dropdown');dd.querySelector('.notif-list').innerHTML='<div class="notif-empty">🔔 All caught up!</div>';var b=dd.closest('.notif-wrap').querySelector('.notif-badge');if(b)b.style.display='none';}
});
// Populate notifications
setTimeout(function(){
  var list=document.querySelector('.notif-list');
  if(list&&!list.children.length){
    var msgs=[
      {i:'📋',c:'ni-info',t:'Your complaint status updated to <strong>In Progress</strong>',time:'5 min ago'},
      {i:'🏥',c:'ni-success',t:'Appointment <strong>confirmed</strong> for tomorrow',time:'1 hour ago'},
      {i:'💡',c:'ni-warning',t:'Electricity bill <strong>due soon</strong>',time:'3 hours ago'}
    ];
    list.innerHTML=msgs.map(function(n){return '<div class="notif-item"><div class="notif-icon '+n.c+'">'+n.i+'</div><div><div class="notif-text">'+n.t+'</div><div class="notif-time">'+n.time+'</div></div></div>';}).join('');
  }
},300);

// Avatar dropdown toggle
document.addEventListener('click',function(e){
  var chip=e.target.closest('#avatarChip');
  if(chip&&!e.target.closest('.avatar-dropdown')){var dd=document.getElementById('avatarDD');dd.classList.toggle('open');e.stopPropagation();return;}
  if(!e.target.closest('.avatar-dropdown'))document.querySelectorAll('.avatar-dropdown.open').forEach(function(d){d.classList.remove('open');});
});
</script>
</body>
</html>
