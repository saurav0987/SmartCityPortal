<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%}
body{
  font-family:'Poppins',-apple-system,sans-serif;
  background:#f0f2f5;
  display:flex;align-items:center;justify-content:center;
  min-height:100vh;padding:24px;
  -webkit-font-smoothing:antialiased;
  position:relative;overflow:hidden;
}

/* ── Background blobs ── */
body::before{
  content:'';position:fixed;
  width:520px;height:520px;border-radius:50%;
  background:radial-gradient(circle,rgba(142,96,255,.18) 0%,transparent 70%);
  top:-140px;left:-140px;pointer-events:none;
}
body::after{
  content:'';position:fixed;
  width:420px;height:420px;border-radius:50%;
  background:radial-gradient(circle,rgba(216,27,96,.14) 0%,transparent 70%);
  bottom:-120px;right:-100px;pointer-events:none;
}
.blob-mid{
  position:fixed;width:300px;height:300px;border-radius:50%;
  background:radial-gradient(circle,rgba(100,150,255,.1) 0%,transparent 70%);
  top:50%;left:50%;transform:translate(-50%,-50%);pointer-events:none;
}

/* ── Card ── */
.card{
  display:flex;width:100%;max-width:820px;min-height:500px;
  border-radius:24px;overflow:hidden;
  box-shadow:0 24px 64px rgba(0,0,0,.13),0 4px 16px rgba(0,0,0,.08);
  position:relative;z-index:1;
}

/* ── LEFT – Form panel ── */
.form-panel{
  flex:1;background:#fff;
  padding:48px 44px;display:flex;flex-direction:column;justify-content:center;
}
.brand{display:flex;align-items:center;gap:10px;margin-bottom:32px}
.brand-icon{
  width:38px;height:38px;border-radius:10px;
  background:linear-gradient(135deg,#d81b60,#7c3aed);
  display:flex;align-items:center;justify-content:center;font-size:18px;
  box-shadow:0 4px 12px rgba(216,27,96,.35);
}
.brand-name{font-size:14px;font-weight:700;color:#111}
.brand-sub{font-size:10px;color:#aaa;font-weight:500}

h2{font-size:22px;font-weight:800;color:#d81b60;margin-bottom:6px;letter-spacing:-.3px}
.tagline{font-size:12px;color:#aaa;margin-bottom:24px}

/* Social login */
.social-row{display:flex;align-items:center;gap:12px;margin-bottom:20px}
.soc-btn{
  width:38px;height:38px;border-radius:50%;border:none;cursor:pointer;
  display:flex;align-items:center;justify-content:center;font-size:15px;
  color:#fff;box-shadow:0 2px 8px rgba(0,0,0,.15);transition:transform .18s,box-shadow .18s;
}
.soc-btn:hover{transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,0,0,.2)}
.soc-fb{background:#3b5998}
.soc-g{background:#db4437}
.soc-tw{background:#1da1f2}
.soc-sep{display:flex;align-items:center;gap:10px;font-size:11px;color:#ccc;margin-bottom:20px}
.soc-sep::before,.soc-sep::after{content:'';flex:1;height:1px;background:#efefef}

/* Alert */
.alert{padding:10px 14px;border-radius:50px;font-size:12px;font-weight:600;margin-bottom:16px;display:flex;align-items:center;gap:8px}
.alert-err{background:#fce4ec;color:#c62828;border:1px solid #f8bbd9}
.alert-ok {background:#e8f5e9;color:#2e7d32;border:1px solid #c8e6c9}

/* Inputs */
.fg{margin-bottom:14px;position:relative}
.fg .fi{
  position:absolute;left:16px;top:50%;transform:translateY(-50%);
  font-size:14px;color:#ccc;pointer-events:none;
}
.fg input{
  width:100%;padding:13px 18px 13px 42px;
  border:none;border-radius:50px;
  background:#f3f3f3;font-size:13px;font-weight:500;
  color:#333;outline:none;font-family:'Poppins',sans-serif;
  transition:background .2s,box-shadow .2s;
}
.fg input:focus{background:#eeeeff;box-shadow:0 0 0 3px rgba(216,27,96,.14)}
.fg input::placeholder{color:#ccc}

.forgot{font-size:11px;color:#aaa;text-align:right;margin:-6px 0 14px;display:block;transition:color .15s}
.forgot:hover{color:#d81b60}

/* Button */
.btn-submit{
  width:100%;padding:14px;border-radius:50px;border:none;cursor:pointer;
  background:linear-gradient(135deg,#d81b60,#ad1457);
  color:#fff;font-size:13px;font-weight:700;letter-spacing:.8px;
  text-transform:uppercase;font-family:'Poppins',sans-serif;
  box-shadow:0 6px 20px rgba(216,27,96,.4);
  transition:all .18s;
}
.btn-submit:hover{box-shadow:0 10px 28px rgba(216,27,96,.55);transform:translateY(-2px)}
.btn-submit:active{transform:scale(.98)}

.bottom-link{text-align:center;font-size:12px;color:#aaa;margin-top:20px}
.bottom-link a{color:#d81b60;font-weight:700;text-decoration:none}
.bottom-link a:hover{color:#ad1457}

/* ── RIGHT – Accent panel ── */
.accent-panel{
  width:42%;background:linear-gradient(160deg,#c2185b 0%,#880e4f 100%);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  padding:48px 36px;text-align:center;position:relative;overflow:hidden;
}
.accent-panel::before{
  content:'';position:absolute;width:280px;height:280px;border-radius:50%;
  border:60px solid rgba(255,255,255,.06);top:-80px;right:-80px;
}
.accent-panel::after{
  content:'';position:absolute;width:200px;height:200px;border-radius:50%;
  border:50px solid rgba(255,255,255,.05);bottom:-60px;left:-60px;
}
.ap-greeting{font-size:28px;font-weight:800;color:#fff;line-height:1.2;margin-bottom:12px;letter-spacing:-.5px;position:relative;z-index:1}
.ap-sub{font-size:13px;color:rgba(255,255,255,.7);line-height:1.7;margin-bottom:32px;position:relative;z-index:1}

/* City illustration (CSS only) */
.city-art{position:relative;z-index:1;margin-bottom:28px;display:flex;flex-direction:column;align-items:center;gap:0}
.city-buildings{display:flex;align-items:flex-end;gap:4px;height:90px}
.bld{border-radius:4px 4px 0 0;position:relative}
.bld::after{content:'';position:absolute;top:6px;left:50%;transform:translateX(-50%);width:60%;height:4px;background:rgba(255,255,255,.2);border-radius:2px}
.b1{width:20px;height:60px;background:rgba(255,255,255,.18)}
.b2{width:28px;height:80px;background:rgba(255,255,255,.22)}
.b3{width:18px;height:50px;background:rgba(255,255,255,.14)}
.b4{width:34px;height:90px;background:rgba(255,255,255,.25)}
.b5{width:22px;height:65px;background:rgba(255,255,255,.18)}
.b6{width:16px;height:44px;background:rgba(255,255,255,.12)}
.b7{width:26px;height:72px;background:rgba(255,255,255,.2)}
.city-base{width:180px;height:4px;background:rgba(255,255,255,.2);border-radius:2px}
.city-icons{display:flex;gap:16px;margin-top:18px}
.ci{
  width:44px;height:44px;border-radius:12px;
  background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.2);
  display:flex;align-items:center;justify-content:center;font-size:20px;
  backdrop-filter:blur(8px);transition:transform .2s;
}
.ci:hover{transform:translateY(-3px)}

.ap-cta{
  display:inline-block;padding:11px 28px;border-radius:50px;
  border:2px solid rgba(255,255,255,.5);color:#fff;font-size:12px;
  font-weight:700;letter-spacing:.5px;text-transform:uppercase;
  font-family:'Poppins',sans-serif;text-decoration:none;
  position:relative;z-index:1;transition:all .18s;
}
.ap-cta:hover{background:rgba(255,255,255,.15);border-color:#fff;color:#fff}

@media(max-width:640px){
  .accent-panel{display:none}
  .form-panel{padding:36px 28px}
  .card{max-width:100%;border-radius:20px}
}
  </style>
</head>
<body>
<div class="blob-mid"></div>

<div class="card">
  <!-- LEFT: Form -->
  <div class="form-panel">
    <div class="brand">
      <div class="brand-icon">🏙️</div>
      <div>
        <div class="brand-name">Smart City Portal</div>
        <div class="brand-sub">Municipal Corporation</div>
      </div>
    </div>

    <h2>Sign In</h2>
    <p class="tagline">Access all city services online</p>

    <c:if test="${not empty success}">
      <div class="alert alert-ok">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-err">⚠️ ${error}</div>
    </c:if>
    <% if (request.getParameter("registered") != null) { %>
      <div class="alert alert-ok">✅ Registered! Please sign in.</div>
    <% } %>

    <div class="social-row">
      <button class="soc-btn soc-fb" title="Facebook">f</button>
      <button class="soc-btn soc-g"  title="Google">G</button>
      <button class="soc-btn soc-tw" title="Twitter">t</button>
    </div>
    <div class="soc-sep">or use your email account</div>

    <form action="login" method="post">
      <div class="fg">
        <span class="fi">✉️</span>
        <input type="email" name="email" required placeholder="Email address" autocomplete="email">
      </div>
      <div class="fg">
        <span class="fi">🔒</span>
        <input type="password" name="password" required placeholder="Password" autocomplete="current-password">
      </div>
      <a href="#" class="forgot">Forgot your password?</a>
      <button type="submit" class="btn-submit">Sign In</button>
    </form>

    <div class="bottom-link" style="margin-top:16px;font-size:11px;color:#ccc">
      Demo: admin@smartcity.com / admin123 &nbsp;|&nbsp; ravi@email.com / pass123
    </div>
    <div class="bottom-link">Don't have an account? <a href="register">Sign up →</a></div>
  </div>

  <!-- RIGHT: Accent -->
  <div class="accent-panel">
    <div class="city-art">
      <div class="city-buildings">
        <div class="bld b1"></div>
        <div class="bld b2"></div>
        <div class="bld b3"></div>
        <div class="bld b4"></div>
        <div class="bld b5"></div>
        <div class="bld b6"></div>
        <div class="bld b7"></div>
      </div>
      <div class="city-base"></div>
      <div class="city-icons">
        <div class="ci">📋</div>
        <div class="ci">🏥</div>
        <div class="ci">💡</div>
        <div class="ci">📢</div>
      </div>
    </div>

    <h3 class="ap-greeting">Hello, Citizen! 👋</h3>
    <p class="ap-sub">Access all your municipal services — complaints, appointments, bills &amp; announcements — right here.</p>
    <a href="register" class="ap-cta">New here? Sign Up</a>
  </div>
</div>

</body>
</html>