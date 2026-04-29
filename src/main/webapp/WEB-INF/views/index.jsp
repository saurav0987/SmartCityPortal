<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Smart City Service Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'Inter',-apple-system,sans-serif;background:#fff;color:#0a0a0a;-webkit-font-smoothing:antialiased}
a{text-decoration:none}

/* NAV */
nav{position:sticky;top:0;z-index:100;background:rgba(255,255,255,.9);backdrop-filter:blur(16px);border-bottom:1px solid #f0f0f0;padding:0 5%;display:flex;align-items:center;justify-content:space-between;height:64px;transition:box-shadow .2s}
nav.sc{box-shadow:0 1px 20px rgba(0,0,0,.08)}
.logo{display:flex;align-items:center;gap:10px}
.logo-icon{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;font-size:18px}
.logo-text{font-size:15px;font-weight:800;color:#0a0a0a}
.logo-sub{font-size:11px;color:#888;font-weight:500}
.nav-links{display:flex;align-items:center;gap:8px}
.nav-link{padding:8px 16px;border-radius:8px;font-size:14px;font-weight:500;color:#444;transition:all .15s}
.nav-link:hover{background:#f5f5f5;color:#0a0a0a}
.nav-cta{padding:8px 18px;border-radius:8px;font-size:14px;font-weight:600;background:#2563eb;color:#fff;border:none;cursor:pointer;transition:all .15s;box-shadow:0 1px 3px rgba(37,99,235,.3)}
.nav-cta:hover{background:#1d4ed8;box-shadow:0 4px 12px rgba(37,99,235,.4);transform:translateY(-1px)}

/* HERO */
.hero{padding:100px 5% 80px;text-align:center;background:#fff;position:relative;overflow:hidden}
.hero::before{content:'';position:absolute;width:800px;height:800px;border-radius:50%;background:radial-gradient(circle,rgba(37,99,235,.06) 0%,transparent 70%);top:-200px;left:50%;transform:translateX(-50%);pointer-events:none}
.hero::after{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none'%3E%3Cg fill='%232563eb' fill-opacity='0.025'%3E%3Ccircle cx='30' cy='30' r='1.5'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");pointer-events:none}
.hero-inner{position:relative;z-index:1}
.hero-tag{display:inline-flex;align-items:center;gap:6px;padding:6px 14px;border-radius:100px;background:#eff6ff;border:1px solid #bfdbfe;color:#1d4ed8;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;margin-bottom:28px}
.hero-tag::before{content:'';width:6px;height:6px;border-radius:50%;background:#2563eb;animation:pulse 2s ease infinite}
@keyframes pulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.5;transform:scale(1.4)}}
h1{font-size:clamp(40px,7vw,72px);font-weight:900;line-height:1.08;letter-spacing:-2px;color:#0a0a0a;margin-bottom:20px}
h1 em{font-style:normal;background:linear-gradient(135deg,#2563eb 0%,#7c3aed 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.hero-desc{font-size:18px;color:#555;max-width:520px;margin:0 auto 36px;line-height:1.7;font-weight:400}
.cta-group{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
.btn-primary{display:inline-flex;align-items:center;gap:6px;padding:14px 28px;border-radius:10px;font-size:15px;font-weight:700;background:#2563eb;color:#fff;border:none;cursor:pointer;box-shadow:0 2px 8px rgba(37,99,235,.35);transition:all .18s}
.btn-primary:hover{background:#1d4ed8;color:#fff;box-shadow:0 8px 24px rgba(37,99,235,.45);transform:translateY(-2px)}
.btn-outline{display:inline-flex;align-items:center;padding:14px 28px;border-radius:10px;font-size:15px;font-weight:600;background:#fff;color:#333;border:1.5px solid #e5e5e5;cursor:pointer;transition:all .18s;box-shadow:0 1px 3px rgba(0,0,0,.05)}
.btn-outline:hover{border-color:#c5c5c5;color:#0a0a0a;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,.08)}
.hero-chips{display:flex;justify-content:center;flex-wrap:wrap;gap:8px;margin-top:40px}
.chip{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border-radius:100px;background:#fafafa;border:1px solid #ebebeb;font-size:13px;font-weight:500;color:#444;transition:all .15s}
.chip:hover{border-color:#bfdbfe;background:#eff6ff;color:#1d4ed8}

/* SOCIAL PROOF */
.proof-bar{background:#f8f9fa;border-top:1px solid #f0f0f0;border-bottom:1px solid #f0f0f0;padding:20px 5%;display:flex;align-items:center;justify-content:center;gap:40px;flex-wrap:wrap}
.proof-item{text-align:center}
.proof-num{font-size:26px;font-weight:900;color:#0a0a0a;letter-spacing:-1px}
.proof-lbl{font-size:12px;color:#888;margin-top:2px;font-weight:500}

/* FEATURES */
.section{padding:80px 5%}
.section-tag{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#2563eb;text-align:center;margin-bottom:12px}
.section-h2{font-size:clamp(28px,4vw,42px);font-weight:800;color:#0a0a0a;text-align:center;letter-spacing:-1px;margin-bottom:12px}
.section-sub{font-size:16px;color:#666;text-align:center;max-width:480px;margin:0 auto 52px;line-height:1.65}
.features-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:20px;max-width:1100px;margin:0 auto}
.feat-card{background:#fff;border:1px solid #ebebeb;border-radius:16px;padding:28px;transition:all .2s;cursor:default}
.feat-card:hover{border-color:#bfdbfe;box-shadow:0 8px 32px rgba(37,99,235,.1);transform:translateY(-4px)}
.feat-icon{width:52px;height:52px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;margin-bottom:18px}
.feat-title{font-size:16px;font-weight:700;color:#0a0a0a;margin-bottom:8px}
.feat-desc{font-size:14px;color:#666;line-height:1.6}

/* HOW */
.how-bg{background:#f8f9fa}
.steps{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:24px;max-width:1000px;margin:0 auto;position:relative}
.steps::before{content:'';position:absolute;top:28px;left:10%;right:10%;height:2px;background:linear-gradient(90deg,#2563eb,#7c3aed);opacity:.15;pointer-events:none}
.step{text-align:center;padding:32px 24px;background:#fff;border:1px solid #ebebeb;border-radius:16px;transition:all .2s}
.step:hover{border-color:#c7d7fd;box-shadow:0 6px 20px rgba(37,99,235,.08);transform:translateY(-3px)}
.step-num{width:48px;height:48px;border-radius:14px;background:linear-gradient(135deg,#2563eb,#7c3aed);color:#fff;font-size:18px;font-weight:800;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;box-shadow:0 4px 12px rgba(37,99,235,.3)}
.step-title{font-size:15px;font-weight:700;color:#0a0a0a;margin-bottom:8px}
.step-desc{font-size:13px;color:#666;line-height:1.6}

/* FAQ */
.faq-wrap{max-width:680px;margin:0 auto}
.faq-item{border:1px solid #ebebeb;border-radius:12px;margin-bottom:10px;overflow:hidden;transition:all .2s;background:#fff}
.faq-item.open{border-color:#bfdbfe;box-shadow:0 0 0 4px rgba(37,99,235,.06)}
.faq-btn{width:100%;display:flex;align-items:center;justify-content:space-between;padding:18px 20px;background:none;border:none;cursor:pointer;font-family:inherit;font-size:15px;font-weight:600;color:#0a0a0a;text-align:left;gap:12px}
.faq-btn:hover{color:#2563eb}
.faq-btn .ico{width:24px;height:24px;border-radius:6px;background:#eff6ff;color:#2563eb;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;transition:transform .25s;font-weight:400}
.faq-item.open .ico{transform:rotate(45deg);background:#2563eb;color:#fff}
.faq-body{max-height:0;overflow:hidden;transition:max-height .3s ease}
.faq-body p{padding:0 20px 18px;font-size:14px;color:#555;line-height:1.7;border-top:1px solid #f5f5f5;padding-top:14px}

/* FOOTER */
footer{background:#0a0a0a;padding:60px 5% 32px}
.footer-grid{display:grid;grid-template-columns:1.5fr 1fr 1fr 1fr;gap:40px;margin-bottom:48px}
.footer-brand .f-logo{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.footer-brand .f-logo-icon{width:32px;height:32px;border-radius:8px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;font-size:16px}
.footer-brand .f-logo-name{font-size:14px;font-weight:800;color:#fff}
.footer-brand p{font-size:13px;color:#666;line-height:1.65;max-width:240px}
.footer-col h4{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:#666;margin-bottom:16px}
.footer-col a{display:block;font-size:13px;color:#888;margin-bottom:10px;transition:color .15s}
.footer-col a:hover{color:#fff}
.footer-bottom{border-top:1px solid #1f1f1f;padding-top:24px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px}
.footer-bottom p{font-size:12px;color:#555}

/* REVEAL */
.reveal{opacity:0;transform:translateY(24px);transition:opacity .55s ease,transform .55s ease}
.reveal.visible{opacity:1;transform:translateY(0)}

/* TOAST */
#toast-box{position:fixed;bottom:24px;right:24px;z-index:9999;display:flex;flex-direction:column;gap:8px;pointer-events:none}
.toast{background:#fff;border:1px solid #ebebeb;border-radius:10px;padding:12px 16px;min-width:260px;max-width:320px;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:500;color:#0a0a0a;box-shadow:0 8px 24px rgba(0,0,0,.12);pointer-events:auto;animation:tin .3s ease both;border-left:3px solid #2563eb}
.toast.success{border-left-color:#16a34a}
.toast.error{border-left-color:#dc2626}
@keyframes tin{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
@keyframes tout{to{opacity:0;transform:translateY(8px)}}
.toast.removing{animation:tout .25s ease forwards}

/* SLIDER */
.slider-section{background:#f8f9fa;padding:56px 5%;border-top:1px solid #f0f0f0;border-bottom:1px solid #f0f0f0}
.slider-label{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#2563eb;text-align:center;margin-bottom:12px}
.slider-heading{font-size:clamp(22px,3.5vw,34px);font-weight:800;color:#0a0a0a;text-align:center;letter-spacing:-1px;margin-bottom:32px}
.slider-wrap{position:relative;max-width:1000px;margin:0 auto;border-radius:20px;overflow:hidden;box-shadow:0 16px 48px rgba(0,0,0,.12)}
.slides{display:flex;transition:transform .55s cubic-bezier(.4,0,.2,1)}
.slide{min-width:100%;height:420px;position:relative;flex-shrink:0}
.slide img{width:100%;height:100%;object-fit:cover;display:block}
.slide-caption{position:absolute;bottom:0;left:0;right:0;padding:28px 32px;background:linear-gradient(to top,rgba(10,10,10,.82) 0%,transparent 100%);color:#fff}
.sc-tag{display:inline-block;background:rgba(37,99,235,.85);color:#fff;font-size:11px;font-weight:700;padding:3px 10px;border-radius:100px;text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px}
.sc-title{font-size:20px;font-weight:800;letter-spacing:-.3px;margin-bottom:4px}
.sc-desc{font-size:13px;color:rgba(255,255,255,.75);line-height:1.5}
.slider-btn{position:absolute;top:50%;transform:translateY(-50%);width:44px;height:44px;border-radius:50%;background:rgba(255,255,255,.92);border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 4px 14px rgba(0,0,0,.15);transition:all .18s;z-index:10;backdrop-filter:blur(6px)}
.slider-btn:hover{background:#fff;box-shadow:0 6px 20px rgba(0,0,0,.2);transform:translateY(-50%) scale(1.08)}
.slider-prev{left:16px}
.slider-next{right:16px}
.slider-dots{display:flex;justify-content:center;gap:8px;margin-top:18px}
.dot{width:8px;height:8px;border-radius:50%;background:#d0d0d0;border:none;cursor:pointer;transition:all .25s;padding:0}
.dot.active{background:#2563eb;width:24px;border-radius:4px}
.slider-progress{position:absolute;bottom:0;left:0;height:3px;background:#2563eb;transition:width .55s linear;z-index:5}
@media(max-width:768px){.slide{height:240px}.slider-section{padding:40px 4%}.sc-title{font-size:15px}.sc-desc{font-size:12px}}

@media(max-width:768px){
  h1{letter-spacing:-1px}
  .hero{padding:70px 5% 60px}
  .proof-bar{gap:20px}
  .footer-grid{grid-template-columns:1fr 1fr}
  .steps::before{display:none}
  .section{padding:60px 5%}
}
@media(max-width:480px){
  .footer-grid{grid-template-columns:1fr}
  .features-grid{grid-template-columns:1fr}
}
  </style>
</head>
<body>

<nav id="nav">
  <div class="logo">
    <div class="logo-icon">🏙️</div>
    <div>
      <div class="logo-text">Smart City Portal</div>
      <div class="logo-sub">Municipal Corporation</div>
    </div>
  </div>
  <div class="nav-links">
    <a href="#features" class="nav-link">Services</a>
    <a href="#how" class="nav-link">How It Works</a>
    <a href="#faq" class="nav-link">FAQ</a>
    <a href="login" class="nav-link">Login</a>
    <a href="register" class="nav-cta">Get Started →</a>
  </div>
</nav>

<section class="hero">
  <div class="hero-inner">
    <div class="hero-tag">🏙️ Municipal Services Online</div>
    <h1>All City Services,<br>Available <em>Online</em></h1>
    <p class="hero-desc">File complaints, book hospital appointments, view utility bills, and read city announcements — without visiting any government office.</p>
    <div class="cta-group">
      <a href="register" class="btn-primary">Create Free Account →</a>
      <a href="login" class="btn-outline">Login to Portal</a>
    </div>
    <div class="hero-chips">
      <span class="chip">📋 Complaints</span>
      <span class="chip">🏥 Appointments</span>
      <span class="chip">💡 Utility Bills</span>
      <span class="chip">📢 Announcements</span>
      <span class="chip">👤 My Profile</span>
    </div>
  </div>
</section>

<!-- ── IMAGE SLIDER ── -->
<section class="slider-section">
  <div class="slider-label">📸 City Highlights</div>
  <h2 class="slider-heading">Smart City in Action</h2>
  <div class="slider-wrap" id="slider">
    <div class="slides" id="slides">
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide1.png" alt="Smart City Skyline" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Infrastructure</span>
          <div class="sc-title">Modern Smart City Skyline</div>
          <div class="sc-desc">A futuristic, connected city built for the future of its citizens.</div>
        </div>
      </div>
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide2.png" alt="File Complaint Online" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Complaints</span>
          <div class="sc-title">File Complaints Instantly Online</div>
          <div class="sc-desc">Report civic issues directly from your home — no office visit required.</div>
        </div>
      </div>
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide3.png" alt="Hospital Appointment" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Healthcare</span>
          <div class="sc-title">Book Hospital Appointments Online</div>
          <div class="sc-desc">Consult city doctors without waiting in long queues at the hospital.</div>
        </div>
      </div>
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide4.png" alt="City Utilities" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Utilities</span>
          <div class="sc-title">Smart Energy &amp; Utility Grid</div>
          <div class="sc-desc">View and pay electricity, water, and tax bills all in one click.</div>
        </div>
      </div>
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide5.png" alt="Digital Citizens" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Citizens</span>
          <div class="sc-title">Empowering Citizens Digitally</div>
          <div class="sc-desc">10,000+ citizens are already managing services from their devices.</div>
        </div>
      </div>
      <div class="slide">
        <img src="${pageContext.request.contextPath}/images/slide6.png" alt="City Roads" loading="lazy">
        <div class="slide-caption">
          <span class="sc-tag">Roads &amp; Parks</span>
          <div class="sc-title">Better Roads, Cleaner City</div>
          <div class="sc-desc">Report road damage and track repairs through the portal in real time.</div>
        </div>
      </div>
    </div>
    <div class="slider-progress" id="sliderProgress"></div>
    <button class="slider-btn slider-prev" id="sliderPrev" aria-label="Previous">&#8249;</button>
    <button class="slider-btn slider-next" id="sliderNext" aria-label="Next">&#8250;</button>
  </div>
  <div class="slider-dots" id="sliderDots"></div>
</section>

<div class="proof-bar">
  <div class="proof-item"><div class="proof-num">10,000+</div><div class="proof-lbl">Citizens Registered</div></div>
  <div class="proof-item"><div class="proof-num">95%</div><div class="proof-lbl">Complaints Resolved</div></div>
  <div class="proof-item"><div class="proof-num">5,000+</div><div class="proof-lbl">Appointments Booked</div></div>
  <div class="proof-item"><div class="proof-num">24 / 7</div><div class="proof-lbl">Portal Availability</div></div>
</div>

<section class="section" id="features">
  <div class="section-tag">What We Offer</div>
  <h2 class="section-h2">Every Municipal Service,<br>In One Place</h2>
  <p class="section-sub">No more office visits. Everything you need is available online, anytime.</p>
  <div class="features-grid">
    <div class="feat-card reveal">
      <div class="feat-icon" style="background:#eff6ff;">📋</div>
      <div class="feat-title">File a Complaint</div>
      <div class="feat-desc">Report road damage, water supply issues, power outages, garbage problems, and more directly to the municipality.</div>
    </div>
    <div class="feat-card reveal" style="transition-delay:.06s">
      <div class="feat-icon" style="background:#f0fdf4;">🔍</div>
      <div class="feat-title">Track Your Complaint</div>
      <div class="feat-desc">Monitor real-time status — Pending, In Progress, or Resolved — from your personal dashboard.</div>
    </div>
    <div class="feat-card reveal" style="transition-delay:.12s">
      <div class="feat-icon" style="background:#fef2f2;">🏥</div>
      <div class="feat-title">Book Appointments</div>
      <div class="feat-desc">Schedule consultations with city hospital doctors online. Pick your specialization, date, and preferred time slot.</div>
    </div>
    <div class="feat-card reveal" style="transition-delay:.18s">
      <div class="feat-icon" style="background:#fffbeb;">💡</div>
      <div class="feat-title">Utility Bills</div>
      <div class="feat-desc">View and pay electricity, water, property tax, and sewage bills online. No more queues at the office.</div>
    </div>
    <div class="feat-card reveal" style="transition-delay:.24s">
      <div class="feat-icon" style="background:#f0f9ff;">📢</div>
      <div class="feat-title">City Announcements</div>
      <div class="feat-desc">Stay informed with official notices, infrastructure updates, event alerts, and emergency notifications.</div>
    </div>
    <div class="feat-card reveal" style="transition-delay:.30s">
      <div class="feat-icon" style="background:#f5f3ff;">🔒</div>
      <div class="feat-title">Secure & Reliable</div>
      <div class="feat-desc">Your data is protected with secure authentication. Access all services reliably 24 hours a day, 7 days a week.</div>
    </div>
  </div>
</section>

<section class="section how-bg" id="how">
  <div class="section-tag">Getting Started</div>
  <h2 class="section-h2">Up & Running in Minutes</h2>
  <p class="section-sub">Four simple steps to access all municipal services online.</p>
  <div class="steps">
    <div class="step reveal">
      <div class="step-num">1</div>
      <div class="step-title">Create Account</div>
      <div class="step-desc">Register for free with your name, email, and address. Takes less than 60 seconds.</div>
    </div>
    <div class="step reveal" style="transition-delay:.1s">
      <div class="step-num">2</div>
      <div class="step-title">Login Securely</div>
      <div class="step-desc">Sign in with your credentials and access your personal citizen dashboard.</div>
    </div>
    <div class="step reveal" style="transition-delay:.2s">
      <div class="step-num">3</div>
      <div class="step-title">Use Services</div>
      <div class="step-desc">File complaints, book appointments, or view bills — all from one clean interface.</div>
    </div>
    <div class="step reveal" style="transition-delay:.3s">
      <div class="step-num">4</div>
      <div class="step-title">Get Updates</div>
      <div class="step-desc">Track status changes and receive updates when your requests are resolved.</div>
    </div>
  </div>
</section>

<section class="section" id="faq">
  <div class="section-tag">FAQ</div>
  <h2 class="section-h2">Frequently Asked Questions</h2>
  <p class="section-sub">Everything you need to know about the portal.</p>
  <div class="faq-wrap">
    <div class="faq-item reveal">
      <button class="faq-btn">Who can register on this portal? <span class="ico">+</span></button>
      <div class="faq-body"><p>Any citizen residing within the municipality can register for free. You only need a valid email address to create an account and access all services immediately.</p></div>
    </div>
    <div class="faq-item reveal" style="transition-delay:.07s">
      <button class="faq-btn">How long does complaint resolution take? <span class="ico">+</span></button>
      <div class="faq-body"><p>Most civic complaints are reviewed within 24–48 hours and resolved within 3–7 working days. You can monitor real-time progress in your dashboard anytime.</p></div>
    </div>
    <div class="faq-item reveal" style="transition-delay:.14s">
      <button class="faq-btn">Is there any fee to use the portal? <span class="ico">+</span></button>
      <div class="faq-body"><p>No. The Smart City Portal is completely free for all citizens. Registration, filing complaints, booking appointments, and reading announcements have no charges.</p></div>
    </div>
    <div class="faq-item reveal" style="transition-delay:.21s">
      <button class="faq-btn">Can I book an appointment for a family member? <span class="ico">+</span></button>
      <div class="faq-body"><p>Yes. When booking, you can enter the patient's name separately. Your citizen account is just for logging in — appointments can be for any individual.</p></div>
    </div>
    <div class="faq-item reveal" style="transition-delay:.28s">
      <button class="faq-btn">What types of complaints can I file? <span class="ico">+</span></button>
      <div class="faq-body"><p>You can file complaints for Roads &amp; Potholes, Water Supply, Electricity &amp; Power, Garbage Collection, Drainage &amp; Sewage, and other civic issues.</p></div>
    </div>
  </div>
</section>

<footer>
  <div class="footer-grid">
    <div class="footer-brand">
      <div class="f-logo">
        <div class="f-logo-icon">🏙️</div>
        <div class="f-logo-name">Smart City Portal</div>
      </div>
      <p>The official online portal for citizens to access all municipal services from anywhere, anytime — free of charge.</p>
    </div>
    <div class="footer-col">
      <h4>Services</h4>
      <a href="register">File Complaint</a>
      <a href="register">Book Appointment</a>
      <a href="register">Utility Bills</a>
      <a href="register">Announcements</a>
    </div>
    <div class="footer-col">
      <h4>Portal</h4>
      <a href="login">Login</a>
      <a href="register">Register</a>
      <a href="#faq">FAQ</a>
      <a href="#how">How It Works</a>
    </div>
    <div class="footer-col">
      <h4>About</h4>
      <a href="#">Municipal Corporation</a>
      <a href="#">Contact Us</a>
      <a href="#">Privacy Policy</a>
      <a href="#">Terms of Use</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 Smart City Portal · Municipal Corporation · B.Tech Java PBL Project</p>
    <p style="color:#555">Built with ❤️ for citizens</p>
  </div>
</footer>

<div id="toast-box"></div>

<script>
(function(){
  // Nav scroll shrink
  var nav=document.getElementById('nav');
  window.addEventListener('scroll',function(){nav.classList.toggle('sc',scrollY>30)},{passive:true});

  // Scroll reveal
  var obs=new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add('visible');obs.unobserve(e.target);}});
  },{threshold:.1,rootMargin:'0px 0px -30px 0px'});
  document.querySelectorAll('.reveal').forEach(function(el){obs.observe(el);});

  // FAQ accordion
  document.querySelectorAll('.faq-btn').forEach(function(btn){
    btn.addEventListener('click',function(){
      var item=btn.closest('.faq-item');
      var body=item.querySelector('.faq-body');
      var open=item.classList.contains('open');
      document.querySelectorAll('.faq-item.open').forEach(function(i){
        i.classList.remove('open');
        i.querySelector('.faq-body').style.maxHeight='0';
        i.querySelector('.ico').textContent='+';
      });
      if(!open){item.classList.add('open');body.style.maxHeight=body.scrollHeight+'px';item.querySelector('.ico').textContent='×';}
    });
  });

  // Smooth anchor scroll
  document.querySelectorAll('a[href^="#"]').forEach(function(a){
    a.addEventListener('click',function(e){
      var t=document.querySelector(a.getAttribute('href'));
      if(t){e.preventDefault();t.scrollIntoView({behavior:'smooth',block:'start'});}
    });
  });

  // Toast helper
  window.showToast=function(msg,type){
    var box=document.getElementById('toast-box');
    var icons={success:'✅',error:'❌',warning:'⚠️',info:'ℹ️'};
    var t=document.createElement('div');
    t.className='toast '+(type||'info');
    t.innerHTML='<span>'+(icons[type]||icons.info)+'</span><span>'+msg+'</span>';
    box.appendChild(t);
    setTimeout(function(){t.classList.add('removing');t.addEventListener('animationend',function(){t.remove();},{once:true});},3500);
  };
  // ── SLIDER ──
  (function(){
    var slides=document.getElementById('slides');
    var dotsWrap=document.getElementById('sliderDots');
    var prog=document.getElementById('sliderProgress');
    var total=6;var cur=0;var timer;var DURATION=4000;

    // Build dots
    for(var i=0;i<total;i++){
      var d=document.createElement('button');
      d.className='dot'+(i===0?' active':'');
      d.setAttribute('aria-label','Slide '+(i+1));
      d.dataset.i=i;
      d.addEventListener('click',function(){goTo(parseInt(this.dataset.i));resetTimer();});
      dotsWrap.appendChild(d);
    }

    function goTo(n){
      cur=(n+total)%total;
      if(slides)slides.style.transform='translateX(-'+cur*100+'%)';
      dotsWrap.querySelectorAll('.dot').forEach(function(d,idx){d.classList.toggle('active',idx===cur);});
      if(prog){prog.style.transition='none';prog.style.width='0';setTimeout(function(){prog.style.transition='width '+DURATION+'ms linear';prog.style.width='100%';},20);}
    }
    function next(){goTo(cur+1);}
    function resetTimer(){clearInterval(timer);timer=setInterval(next,DURATION);}

    document.getElementById('sliderNext').addEventListener('click',function(){next();resetTimer();});
    document.getElementById('sliderPrev').addEventListener('click',function(){goTo(cur-1);resetTimer();});

    // Keyboard
    document.addEventListener('keydown',function(e){
      if(e.key==='ArrowRight'){next();resetTimer();}
      if(e.key==='ArrowLeft'){goTo(cur-1);resetTimer();}
    });

    // Touch swipe
    var touchX=0;
    var sl=document.getElementById('slider');
    if(sl){
      sl.addEventListener('touchstart',function(e){touchX=e.touches[0].clientX;},{passive:true});
      sl.addEventListener('touchend',function(e){
        var dx=e.changedTouches[0].clientX-touchX;
        if(Math.abs(dx)>40){dx<0?next():goTo(cur-1);resetTimer();}
      },{passive:true});
    }

    goTo(0);resetTimer();
  })();
})();
</script>
</body>
</html>
