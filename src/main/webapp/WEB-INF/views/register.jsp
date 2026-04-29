<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',-apple-system,sans-serif;background:#fff;color:#0a0a0a;-webkit-font-smoothing:antialiased;min-height:100vh;display:flex}
a{text-decoration:none}

/* ── LEFT PANEL ── */
.left{
  width:48%;background:linear-gradient(145deg,#064e3b 0%,#059669 45%,#10b981 100%);
  display:flex;flex-direction:column;justify-content:space-between;padding:48px;
  position:relative;overflow:hidden;
}
.left::before{content:'';position:absolute;width:500px;height:500px;border-radius:50%;background:rgba(255,255,255,.05);top:-120px;right:-150px;pointer-events:none}
.left::after{content:'';position:absolute;width:280px;height:280px;border-radius:50%;background:rgba(255,255,255,.04);bottom:-60px;left:-50px;pointer-events:none}
.left-logo{display:flex;align-items:center;gap:12px;position:relative;z-index:1}
.left-logo-icon{width:42px;height:42px;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px}
.left-logo-name{font-size:15px;font-weight:800;color:#fff}
.left-logo-sub{font-size:11px;color:rgba(255,255,255,.6);font-weight:500}
.left-content{position:relative;z-index:1}
.left-content h1{font-size:clamp(26px,3vw,40px);font-weight:900;color:#fff;line-height:1.15;letter-spacing:-1.5px;margin-bottom:14px}
.left-content h1 span{color:rgba(167,243,208,1)}
.left-content p{font-size:14px;color:rgba(255,255,255,.72);line-height:1.7;max-width:360px}
.perks{display:flex;flex-direction:column;gap:10px;margin-top:24px;position:relative;z-index:1}
.perk{display:flex;align-items:center;gap:10px}
.perk-check{width:22px;height:22px;background:rgba(255,255,255,.15);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11px;color:#fff;flex-shrink:0;font-weight:700}
.perk-text{font-size:13px;color:rgba(255,255,255,.85);font-weight:500}
.left-bottom{font-size:12px;color:rgba(255,255,255,.4);position:relative;z-index:1}

/* ── RIGHT PANEL ── */
.right{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 32px;background:#fff;overflow-y:auto}
.form-box{width:100%;max-width:400px;padding:8px 0}
.form-box .top-brand{display:flex;align-items:center;gap:10px;margin-bottom:28px}
.form-box .top-brand .ti{width:38px;height:38px;background:linear-gradient(135deg,#059669,#10b981);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;box-shadow:0 4px 12px rgba(5,150,105,.3)}
.form-box .top-brand .tn{font-size:14px;font-weight:700;color:#0a0a0a}
h2{font-size:26px;font-weight:900;color:#0a0a0a;letter-spacing:-1px;margin-bottom:6px}
.sub{font-size:14px;color:#888;margin-bottom:24px}

.alert-err{background:#fef2f2;border-left:3px solid #dc2626;color:#991b1b;padding:12px 14px;border-radius:8px;font-size:13px;font-weight:500;margin-bottom:16px}

.fg{margin-bottom:14px}
.fg label{display:block;font-size:12px;font-weight:700;color:#333;margin-bottom:6px;text-transform:uppercase;letter-spacing:.4px}
.fg input{width:100%;padding:12px 14px;border:1.5px solid #e8e8e8;border-radius:10px;font-size:14px;color:#0a0a0a;background:#fafafa;outline:none;font-family:inherit;transition:all .18s}
.fg input:focus{border-color:#059669;background:#fff;box-shadow:0 0 0 4px rgba(5,150,105,.1)}
.fg input::placeholder{color:#bbb}
.two{display:grid;grid-template-columns:1fr 1fr;gap:12px}

.btn-submit{width:100%;padding:14px;border-radius:10px;background:linear-gradient(135deg,#059669,#10b981);color:#fff;font-size:15px;font-weight:700;border:none;cursor:pointer;font-family:inherit;box-shadow:0 4px 14px rgba(5,150,105,.35);transition:all .18s;margin-top:4px}
.btn-submit:hover{box-shadow:0 8px 24px rgba(5,150,105,.5);transform:translateY(-2px)}
.btn-submit:active{transform:scale(.98)}

.divider{display:flex;align-items:center;gap:12px;margin:18px 0;color:#ccc;font-size:12px}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:#f0f0f0}
.bottom-link{text-align:center;font-size:13px;color:#888}
.bottom-link a{color:#059669;font-weight:700}
.back{display:block;text-align:center;font-size:12px;color:#bbb;margin-top:16px;transition:color .15s}
.back:hover{color:#666}

.terms-note{font-size:11.5px;color:#aaa;text-align:center;margin-top:14px;line-height:1.6}
.terms-note a{color:#059669}

@media(max-width:768px){.left{display:none}.right{padding:32px 20px}}
  </style>
</head>
<body>

<div class="left">
  <div class="left-logo">
    <div class="left-logo-icon">🏙️</div>
    <div>
      <div class="left-logo-name">Smart City Portal</div>
      <div class="left-logo-sub">Municipal Corporation</div>
    </div>
  </div>
  <div class="left-content">
    <h1>Join <span>10,000+</span> Citizens Online</h1>
    <p>Create your free account and start accessing all municipal services from your home — no office visits required.</p>
    <div class="perks">
      <div class="perk"><div class="perk-check">✓</div><div class="perk-text">File civic complaints instantly</div></div>
      <div class="perk"><div class="perk-check">✓</div><div class="perk-text">Book hospital appointments online</div></div>
      <div class="perk"><div class="perk-check">✓</div><div class="perk-text">View &amp; pay utility bills anytime</div></div>
      <div class="perk"><div class="perk-check">✓</div><div class="perk-text">Receive official city announcements</div></div>
      <div class="perk"><div class="perk-check">✓</div><div class="perk-text">100% free — no charges ever</div></div>
    </div>
  </div>
  <div class="left-bottom">© 2026 Smart City Portal · B.Tech Java PBL</div>
</div>

<div class="right">
  <div class="form-box">
    <div class="top-brand">
      <div class="ti">🏙️</div>
      <div class="tn">Smart City Portal</div>
    </div>
    <h2>Create your account</h2>
    <p class="sub">Free forever. Takes less than 60 seconds.</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-err">⚠️ ${error}</div>
    <% } %>

    <form action="register" method="post">
      <div class="fg">
        <label>Full Name *</label>
        <input type="text" name="name" required placeholder="e.g. Ravi Sharma">
      </div>
      <div class="fg">
        <label>Email Address *</label>
        <input type="email" name="email" required placeholder="you@example.com">
      </div>
      <div class="fg">
        <label>Password *</label>
        <input type="password" name="password" required placeholder="Minimum 6 characters" minlength="6">
      </div>
      <div class="two">
        <div class="fg">
          <label>Phone</label>
          <input type="tel" name="phone" placeholder="10-digit number">
        </div>
        <div class="fg">
          <label>Area / Address</label>
          <input type="text" name="address" placeholder="e.g. MG Road">
        </div>
      </div>
      <button type="submit" class="btn-submit">Create Free Account →</button>
    </form>

    <p class="terms-note">By registering, you agree to the <a href="#">Terms of Use</a> and <a href="#">Privacy Policy</a> of the Smart City Portal.</p>

    <div class="divider">or</div>
    <div class="bottom-link">Already have an account? <a href="login">Sign in →</a></div>
    <a href="./" class="back">← Back to Home</a>
  </div>
</div>

</body>
</html>
