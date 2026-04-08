<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; }

    /* Left panel – background image */
    .left-panel {
      flex: 1;
      background-image: url('images/hero-bg.png');
      background-size: cover;
      background-position: center;
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 2.5rem;
    }
    .left-panel::before {
      content: '';
      position: absolute; inset: 0;
      background: linear-gradient(to top, rgba(10,13,22,0.92) 0%, rgba(10,13,22,0.4) 60%, rgba(10,13,22,0.2) 100%);
    }
    .left-content { position: relative; z-index: 1; }
    .left-content .portal-logo {
      width: 42px; height: 42px; background: #2563eb; border-radius: 9px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.3rem; margin-bottom: 2rem;
    }
    .left-content h1 { font-size: 1.9rem; font-weight: 700; color: #f9fafb; line-height: 1.25; margin-bottom: .75rem; }
    .left-content h1 span { color: #60a5fa; }
    .left-content p  { font-size: .88rem; color: #9ca3af; line-height: 1.65; max-width: 380px; }

    .service-pills {
      display: flex; flex-wrap: wrap; gap: .5rem; margin-top: 1.25rem;
    }
    .service-pills span {
      background: rgba(255,255,255,.08); border: 1px solid rgba(255,255,255,.12);
      color: #d1d5db; font-size: .72rem; padding: .25rem .65rem; border-radius: 4px;
    }

    /* Right panel – login form */
    .right-panel {
      width: 420px; flex-shrink: 0;
      background: #0f1117;
      border-left: 1px solid #1f2937;
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      padding: 2.5rem 2rem;
    }
    .form-wrap { width: 100%; max-width: 340px; }

    .form-wrap .logo-mini {
      width: 38px; height: 38px; background: #2563eb; border-radius: 8px;
      display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
      margin-bottom: 1.25rem;
    }
    .form-wrap h2 { font-size: 1.2rem; font-weight: 700; color: #f9fafb; margin-bottom: .25rem; }
    .form-wrap .sub { font-size: .78rem; color: #6b7280; margin-bottom: 1.75rem; }

    .form-group { margin-bottom: .85rem; }
    .form-group label { display: block; font-size: .76rem; color: #9ca3af; font-weight: 500; margin-bottom: .35rem; }
    .form-group input {
      width: 100%; background: #161b27; border: 1px solid #2a3347; color: #e5e7eb;
      padding: .55rem .8rem; border-radius: 7px; font-size: .84rem; outline: none;
      font-family: inherit; transition: border-color .15s;
    }
    .form-group input:focus { border-color: #2563eb; }
    .form-group input::placeholder { color: #374151; }

    .btn-login {
      width: 100%; padding: .6rem; border-radius: 7px;
      background: #2563eb; color: #fff; font-size: .88rem; font-weight: 600;
      border: none; cursor: pointer; margin-top: .25rem; transition: background .15s;
    }
    .btn-login:hover { background: #1d4ed8; }

    .divider { border: none; border-top: 1px solid #1f2937; margin: 1.25rem 0; }

    .link-row { text-align: center; font-size: .78rem; color: #6b7280; }
    .link-row a { color: #60a5fa; text-decoration: none; }

    .creds-box {
      margin-top: 1.5rem; background: #161b27;
      border: 1px solid #2a3347; border-radius: 8px; padding: .85rem;
    }
    .creds-box .creds-title { font-size: .67rem; text-transform: uppercase; letter-spacing: .5px; color: #4b5563; font-weight: 600; margin-bottom: .6rem; }
    .creds-grid { display: grid; grid-template-columns: 1fr 1fr; gap: .5rem; }
    .cred-item { background: #0d1117; border: 1px solid #1f2937; border-radius: 6px; padding: .55rem; }
    .cred-item .role { font-size: .72rem; font-weight: 600; margin-bottom: .25rem; }
    .cred-item .val  { font-size: .71rem; color: #6b7280; line-height: 1.5; }

    .alert-err {
      background: rgba(220,38,38,.08); border-left: 3px solid #dc2626;
      color: #fca5a5; padding: .6rem .8rem; border-radius: 6px;
      font-size: .78rem; margin-bottom: 1rem;
    }
    .alert-ok {
      background: rgba(22,163,74,.08); border-left: 3px solid #16a34a;
      color: #86efac; padding: .6rem .8rem; border-radius: 6px;
      font-size: .78rem; margin-bottom: 1rem;
    }
    .back-home { text-align: center; margin-top: 1.25rem; font-size: .73rem; }
    .back-home a { color: #4b5563; text-decoration: none; }
    .back-home a:hover { color: #9ca3af; }

    @media (max-width: 768px) {
      .left-panel { display: none; }
      .right-panel { width: 100%; border: none; }
    }
  </style>
</head>
<body>

  <!-- Left – City Image -->
  <div class="left-panel">
    <div class="left-content">
      <div class="portal-logo">🏙️</div>
      <h1>Smart City<br><span>Service Portal</span></h1>
      <p>The official online portal for citizens to access municipal services — complaints, appointments, bills, and city announcements — all in one place.</p>
      <div class="service-pills">
        <span>📋 Complaints</span>
        <span>🏥 Appointments</span>
        <span>💡 Utility Bills</span>
        <span>📢 Announcements</span>
        <span>👤 My Profile</span>
      </div>
    </div>
  </div>

  <!-- Right – Login Form -->
  <div class="right-panel">
    <div class="form-wrap">

      <div class="logo-mini">🏙️</div>
      <h2>Sign In</h2>
      <p class="sub">Enter your citizen account credentials</p>

      <% if (request.getParameter("registered") != null) { %>
        <div class="alert-ok">Registration successful. You can now login.</div>
      <% } %>
      <% if (request.getAttribute("error") != null) { %>
        <div class="alert-err"><%= request.getAttribute("error") %></div>
      <% } %>

      <form action="login" method="post">
        <div class="form-group">
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" required
                 placeholder="you@example.com" autocomplete="email">
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" required
                 placeholder="Your password" autocomplete="current-password">
        </div>
        <button type="submit" class="btn-login">Login →</button>
      </form>

      <hr class="divider">

      <div class="link-row">
        Don't have an account? <a href="register.jsp">Register here</a>
      </div>

      <!-- Test credentials -->
      <div class="creds-box">
        <div class="creds-title">Test Credentials</div>
        <div class="creds-grid">
          <div class="cred-item">
            <div class="role" style="color:#c4b5fd;">Admin</div>
            <div class="val">admin@smartcity.com<br>admin123</div>
          </div>
          <div class="cred-item">
            <div class="role" style="color:#93c5fd;">Citizen</div>
            <div class="val">ravi@email.com<br>pass123</div>
          </div>
        </div>
      </div>

      <div class="back-home"><a href="index.jsp">← Back to Home</a></div>
    </div>
  </div>

</body>
</html>