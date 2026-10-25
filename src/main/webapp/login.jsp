<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Login | IronCore Gym</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="login-wrap">
  <div class="login-card card-box p-4">
    <div class="text-center mb-4">
      <div class="brand border-0 p-0 fs-2"><i class="bi bi-lightning-charge-fill text-warning"></i> Iron<span>Core</span></div>
      <p class="text-secondary mb-0">Gym Management System &middot; Admin sign in</p>
    </div>

    <%-- LoginServlet sets request attribute "error" on failure and "msg" after logout --%>
    <c:if test="${not empty error}"><div class="alert alert-danger" role="alert"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${error}"/></div></c:if>
    <c:if test="${not empty param.logout}"><div class="alert alert-success" role="alert"><i class="bi bi-check-circle me-2"></i>You have been logged out.</div></c:if>

    <form action="${ctx}/login" method="post" class="needs-validation" novalidate>
      <div class="mb-3">
        <label for="username" class="form-label">Username</label>
        <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" minlength="3" required autofocus>
        <div class="invalid-feedback">Enter your username (at least 3 characters).</div>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <div class="input-group has-validation">
          <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" minlength="6" required>
          <button class="btn btn-ghost" type="button" id="showPw" aria-label="Show password"><i class="bi bi-eye"></i></button>
          <div class="invalid-feedback">Enter your password (at least 6 characters).</div>
        </div>
      </div>
      <button type="submit" class="btn btn-orange w-100 py-2">Sign in</button>
    </form>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/assets/js/app.js"></script>
<script>
  document.getElementById('showPw').addEventListener('click', () => {
    const p = document.getElementById('password'); p.type = p.type === 'password' ? 'text' : 'password';
  });
</script>
</body>
</html>
