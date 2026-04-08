<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register – Smart City Portal</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; }

    .left-panel {
      flex: 1;
      background-image: url('images/services-bg.png');
      background-size: cover; background-position: center;
      position: relative; display: flex; flex-direction: column;
      justify-content: flex-end; padding: 2.5rem;
    }
    .left-panel::before {
      content: ''; position: absolute; inset: 0;
      background: linear-gradient(to top, rgba(10,13,22,0.92) 0%, rgba(10,13,22,0.35) 100%);
    }
    .left-content { position: relative; z-index: 1; }
    .left-content .portal-logo {
      width: 42px; height: 42px; background: #2563eb; border-radius: 9px;
      display: flex; align-items: center; justify-content: center; font-size: 1.3rem;
      margin-bottom: 2rem;
    }
    .left-content h1 { font-size: 1.75rem; font-weight: 700; color: #f9fafb; line-height: 1.3; margin-bottom: .65rem; }
    .left-content p  { font-size: .86rem; color: #9ca3af; line-height: 1.65; max-width: 380px; }

    .feature-list { margin-top: 1.25rem; display: flex; flex-direction: column; gap: .5rem; }
    .feature-list .fi {
      display: flex; align-items: center; gap: .6rem;
      font-size: .8rem; color: #d1d5db;
    }
    .feature-list .fi .fi-icon {
      width: 26px; height: 26px; background: rgba(37,99,235,.2);
      border: 1px solid rgba(37,99,235,.35); border-radius: 5px;
      display: flex; align-items: center; justify-content: center; font-size: .85rem;
    }

    .right-panel {
      width: 440px; flex-shrink: 0; background: #0f1117;
      border-left: 1px solid #1f2937;
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      padding: 2.5rem 2rem; overflow-y: auto;
    }
    .form-wrap { width: 100%; max-width: 360px; }
    .form-wrap .logo-mini {
      width: 38px; height: 38px; background: #2563eb; border-radius: 8px;
      display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
      margin-bottom: 1.1rem;
    }
    .form-wrap h2 { font-size: 1.15rem; font-weight: 700; color: #f9fafb; margin-bottom: .2rem; }
    .form-wrap .sub { font-size: .77rem; color: #6b7280; margin-bottom: 1.5rem; }

    .form-group { margin-bottom: .75rem; }
    .form-group label { display: block; font-size: .75rem; color: #9ca3af; font-weight: 500; margin-bottom: .3rem; }
    .form-group input, .form-group textarea {
      width: 100%; background: #161b27; border: 1px solid #2a3347; color: #e5e7eb;
      padding: .52rem .8rem; border-radius: 7px; font-size: .83rem; outline: none;
      font-family: inherit; transition: border-color .15s; resize: none;
    }
    .form-group input:focus, .form-group textarea:focus { border-color: #2563eb; }
    .form-group input::placeholder { color: #374151; }
    .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: .75rem; }

    .btn-reg {
      width: 100%; padding: .6rem; border-radius: 7px;
      background: #2563eb; color: #fff; font-size: .87rem; font-weight: 600;
      border: none; cursor: pointer; margin-top: .25rem; transition: background .15s;
    }
    .btn-reg:hover { background: #1d4ed8; }

    .divider { border: none; border-top: 1px solid #1f2937; margin: 1.1rem 0; }
    .link-row { text-align: center; font-size: .77rem; color: #6b7280; }
    .link-row a { color: #60a5fa; text-decoration: none; }
    .back-home { text-align: center; margin-top: .9rem; font-size: .72rem; }
    .back-home a { color: #4b5563; text-decoration: none; }
    .back-home a:hover { color: #9ca3af; }
    .alert-err { background: rgba(220,38,38,.08); border-left: 3px solid #dc2626; color: #fca5a5; padding: .6rem .8rem; border-radius: 6px; font-size: .77rem; margin-bottom: .9rem; }

    @media (max-width: 768px) { .left-panel { display: none; } .right-panel { width: 100%; border: none; } }
  </style>
</head>
<body>

  <!-- Left - City Image -->
  <div class="left-panel">
    <div class="left-content">
      <div class="portal-logo">🏙️</div>
      <h1>Join the Smart City Portal</h1>
      <p>Register as a citizen to access all municipal services from your computer or phone — free of charge, anytime.</p>
      <div class="feature-list">
        <div class="fi"><div class="fi-icon">📋</div>File and track civic complaints</div>
        <div class="fi"><div class="fi-icon">🏥</div>Book hospital appointments online</div>
        <div class="fi"><div class="fi-icon">💡</div>View and pay utility bills</div>
        <div class="fi"><div class="fi-icon">📢</div>Receive official city announcements</div>
      </div>
    </div>
  </div>

  <!-- Right - Registration Form -->
  <div class="right-panel">
    <div class="form-wrap">

      <div class="logo-mini">🏙️</div>
      <h2>Citizen Registration</h2>
      <p class="sub">Create your account to access city services</p>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert-err"><%= request.getAttribute("error") %></div>
      <% } %>

      <form action="register" method="post">
        <div class="form-group">
          <label for="name">Full Name *</label>
          <input type="text" id="name" name="name" required placeholder="e.g. Ravi Sharma">
        </div>
        <div class="form-group">
          <label for="email">Email Address *</label>
          <input type="email" id="email" name="email" required placeholder="you@example.com">
        </div>
        <div class="form-group">
          <label for="password">Password *</label>
          <input type="password" id="password" name="password" required
                 placeholder="Minimum 6 characters" minlength="6">
        </div>
        <div class="two-col">
          <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" name="phone" placeholder="10-digit number">
          </div>
          <div class="form-group">
            <label for="address">Address / Area</label>
            <input type="text" id="address" name="address" placeholder="e.g. MG Road, Block A">
          </div>
        </div>
        <button type="submit" class="btn-reg">Create Account →</button>
      </form>

      <hr class="divider">
      <div class="link-row">Already have an account? <a href="login.jsp">Login here</a></div>
      <div class="back-home"><a href="index.jsp">← Back to Home</a></div>
    </div>
  </div>

</body>
</html>
