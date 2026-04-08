<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Error – Smart City Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card" style="text-align:center;">
    <div style="font-size:4rem;margin-bottom:1rem;">⚠️</div>
    <h2 style="margin-bottom:.5rem;">Something went wrong</h2>
    <p class="text-muted" style="margin-bottom:1.5rem;">
      The page you're looking for could not be found or an internal error occurred.
    </p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">← Back to Home</a>
  </div>
</div>
</body>
</html>
