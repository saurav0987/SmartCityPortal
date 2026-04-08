<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Smart City Service Portal</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Inter', sans-serif; background: #0f1117; color: #d1d5db; margin: 0; }
    a { text-decoration: none; }

    /* ── Hero Section ── */
    .hero-wrap {
      min-height: 100vh;
      background-image: url('images/hero-bg.png');
      background-size: cover;
      background-position: center top;
      position: relative;
      display: flex;
      flex-direction: column;
    }
    .hero-wrap::after {
      content: '';
      position: absolute; inset: 0;
      background: linear-gradient(to bottom,
        rgba(10,13,22,0.65) 0%,
        rgba(10,13,22,0.78) 50%,
        rgba(10,13,22,0.97) 100%);
    }
    .hero-inner { position: relative; z-index: 2; flex: 1; display: flex; flex-direction: column; }

    /* ── Navbar ── */
    .top-nav {
      padding: 1rem 2rem;
      display: flex; align-items: center; justify-content: space-between;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .brand { display: flex; align-items: center; gap: .6rem; }
    .brand-icon {
      width: 36px; height: 36px; background: #2563eb; border-radius: 8px;
      display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
    }
    .brand-name { font-size: .95rem; font-weight: 700; color: #f9fafb; }
    .brand-sub  { font-size: .66rem; color: #6b7280; }
    .nav-btns   { display: flex; gap: .6rem; }
    .btn-nav-login {
      padding: .38rem .9rem; border-radius: 6px; font-size: .82rem; font-weight: 500;
      border: 1px solid #374151; color: #d1d5db; background: transparent;
    }
    .btn-nav-login:hover { background: rgba(255,255,255,.06); color: #f9fafb; }
    .btn-nav-reg {
      padding: .38rem .9rem; border-radius: 6px; font-size: .82rem; font-weight: 500;
      background: #2563eb; color: #fff; border: none;
    }
    .btn-nav-reg:hover { background: #1d4ed8; color: #fff; }

    /* ── Hero Text ── */
    .hero-section {
      flex: 1; display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      text-align: center; padding: 4rem 1.5rem 3rem;
    }
    .portal-tag {
      display: inline-block; background: rgba(37,99,235,.15);
      border: 1px solid rgba(37,99,235,.35); color: #93c5fd;
      font-size: .72rem; font-weight: 600; letter-spacing: .5px;
      text-transform: uppercase; padding: .3rem .9rem; border-radius: 4px;
      margin-bottom: 1.4rem;
    }
    .hero-title {
      font-size: clamp(2rem, 4.5vw, 3rem);
      font-weight: 700; color: #f9fafb; line-height: 1.18;
      max-width: 680px; margin-bottom: 1rem;
    }
    .hero-title span { color: #60a5fa; }
    .hero-desc {
      font-size: .97rem; color: #9ca3af;
      max-width: 520px; line-height: 1.72; margin-bottom: 2rem;
    }
    .hero-cta { display: flex; gap: .75rem; flex-wrap: wrap; justify-content: center; }
    .btn-cta-primary {
      padding: .65rem 1.75rem; border-radius: 7px; font-size: .9rem;
      font-weight: 600; background: #2563eb; color: #fff; border: none;
    }
    .btn-cta-primary:hover { background: #1d4ed8; color: #fff; }
    .btn-cta-outline {
      padding: .65rem 1.75rem; border-radius: 7px; font-size: .9rem;
      font-weight: 600; background: transparent;
      border: 1px solid rgba(255,255,255,.2); color: #d1d5db;
    }
    .btn-cta-outline:hover { background: rgba(255,255,255,.06); color: #f9fafb; }

    /* ── Services Section ── */
    .services-section {
      background: #161b27;
      border-top: 1px solid #1f2937; border-bottom: 1px solid #1f2937;
      padding: 3rem 2rem;
    }
    .section-title { font-size: 1rem; font-weight: 600; color: #e5e7eb; text-align: center; margin-bottom: 1.5rem; }
    .svc-card {
      background: #1c2333; border: 1px solid #2a3347; border-radius: 10px;
      padding: 1.2rem; height: 100%; transition: border-color .15s;
    }
    .svc-card:hover { border-color: #374151; }
    .svc-icon { font-size: 1.6rem; margin-bottom: .6rem; display: block; }
    .svc-title { font-size: .88rem; font-weight: 600; color: #e5e7eb; margin-bottom: .3rem; }
    .svc-desc  { font-size: .78rem; color: #6b7280; line-height: 1.55; }

    /* ── How It Works ── */
    .how-section { background: #0f1117; padding: 3rem 2rem 3.5rem; }
    .step-card {
      background: #1c2333; border: 1px solid #2a3347; border-radius: 10px;
      padding: 1.2rem; height: 100%;
    }
    .step-num {
      width: 30px; height: 30px; background: #2563eb; border-radius: 6px;
      display: inline-flex; align-items: center; justify-content: center;
      font-size: .8rem; font-weight: 700; color: #fff; margin-bottom: .65rem;
    }
    .step-title { font-size: .88rem; font-weight: 600; color: #e5e7eb; margin-bottom: .3rem; }
    .step-desc  { font-size: .78rem; color: #6b7280; line-height: 1.55; }

    /* ── Footer ── */
    .land-footer {
      background: #161b27; border-top: 1px solid #1f2937;
      padding: 1rem 2rem;
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: .5rem;
    }
    .land-footer span { font-size: .73rem; color: #4b5563; }
    .land-footer a    { font-size: .73rem; color: #6b7280; }
    .land-footer a:hover { color: #9ca3af; }
  </style>
</head>
<body>

<div class="hero-wrap">
  <div class="hero-inner">

    <!-- Navbar -->
    <nav class="top-nav">
      <div class="brand">
        <div class="brand-icon">🏙️</div>
        <div>
          <div class="brand-name">Smart City Portal</div>
          <div class="brand-sub">Municipal Corporation</div>
        </div>
      </div>
      <div class="nav-btns">
        <a href="login.jsp"    class="btn-nav-login">Login</a>
        <a href="register.jsp" class="btn-nav-reg">Register</a>
      </div>
    </nav>

    <!-- Hero -->
    <section class="hero-section">
      <span class="portal-tag">Municipal Services &middot; Online Portal</span>
      <h1 class="hero-title">
        All City Services<br>
        Available <span>Online</span>
      </h1>
      <p class="hero-desc">
        File complaints about civic issues, book hospital appointments,
        view your utility bills, and read official city announcements —
        all from a single portal, without visiting any government office.
      </p>
      <div class="hero-cta">
        <a href="register.jsp" class="btn-cta-primary">Create Citizen Account</a>
        <a href="login.jsp"    class="btn-cta-outline">Login</a>
      </div>
    </section>

  </div>
</div>

<!-- Services Section -->
<section class="services-section">
  <div class="container-fluid" style="max-width:1050px;">
    <div class="section-title">Services Available on This Portal</div>
    <div class="row g-3">
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">📋</span>
          <div class="svc-title">File Complaint</div>
          <div class="svc-desc">Report road, water, electricity, or garbage issues to the municipality.</div>
        </div>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">🔍</span>
          <div class="svc-title">Track Status</div>
          <div class="svc-desc">Monitor your complaint — Pending, In Progress, or Resolved.</div>
        </div>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">🏥</span>
          <div class="svc-title">Appointments</div>
          <div class="svc-desc">Book a consultation with any city hospital doctor online.</div>
        </div>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">💡</span>
          <div class="svc-title">Utility Bills</div>
          <div class="svc-desc">View electricity, water, tax, and sewage bills. Pay online.</div>
        </div>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">📢</span>
          <div class="svc-title">Announcements</div>
          <div class="svc-desc">Read official city notices, alerts, events, and maintenance updates.</div>
        </div>
      </div>
      <div class="col-6 col-md-4 col-lg-2">
        <div class="svc-card">
          <span class="svc-icon">👤</span>
          <div class="svc-title">My Account</div>
          <div class="svc-desc">Manage your profile and access all your service history.</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- How It Works -->
<section class="how-section">
  <div class="container-fluid" style="max-width:960px;">
    <div class="section-title">How to Get Started</div>
    <div class="row g-3">
      <div class="col-6 col-md-3">
        <div class="step-card">
          <div class="step-num">1</div>
          <div class="step-title">Register</div>
          <div class="step-desc">Create a free citizen account with your name, email, and address.</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="step-card">
          <div class="step-num">2</div>
          <div class="step-title">Login</div>
          <div class="step-desc">Sign in with your registered email and password.</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="step-card">
          <div class="step-num">3</div>
          <div class="step-title">Use Services</div>
          <div class="step-desc">File complaints, book appointments, or pay bills from your dashboard.</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="step-card">
          <div class="step-num">4</div>
          <div class="step-title">Get Updates</div>
          <div class="step-desc">Track your requests and see when they are resolved or confirmed.</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Footer -->
<footer class="land-footer">
  <span>Smart City Service Portal &mdash; Municipal Corporation</span>
  <div style="display:flex;gap:1.25rem;">
    <a href="login.jsp">Admin Login</a>
    <a href="register.jsp">Register</a>
  </div>
  <span>B.Tech Java PBL Project &middot; 2026</span>
</footer>

</body>
</html>
