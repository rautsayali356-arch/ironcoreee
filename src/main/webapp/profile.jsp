<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Profile"/><c:set var="active" value="profile"/>
<%@ include file="includes/header.jsp" %>
<%--
  Uses session attribute "admin" (set by LoginServlet): adminId, fullName, username, email, role.
  Change password -> POST /profile with action=password (currentPassword, newPassword).
--%>
<div class="page-head"><h1>Admin profile</h1>
  <button class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#logoutModal"><i class="bi bi-box-arrow-right me-1"></i>Log out</button></div>

<div class="row g-3">
  <div class="col-12 col-lg-5">
    <div class="card-box text-center">
      <span class="avatar mb-3" style="width:80px;height:80px;font-size:2rem">${sessionScope.admin.fullName.substring(0,1)}</span>
      <h2 class="mb-1"><c:out value="${sessionScope.admin.fullName}"/></h2>
      <p class="text-secondary mb-3"><c:out value="${empty sessionScope.admin.role ? 'Administrator' : sessionScope.admin.role}"/></p>
      <ul class="list-unstyled text-start mb-0">
        <li class="py-2 border-top border-secondary-subtle"><i class="bi bi-person me-2 text-warning"></i>Username: <c:out value="${sessionScope.admin.username}"/></li>
        <li class="py-2 border-top border-secondary-subtle"><i class="bi bi-envelope me-2 text-warning"></i><c:out value="${sessionScope.admin.email}"/></li>
      </ul>
    </div>
  </div>
  <div class="col-12 col-lg-7">
    <div class="card-box"><h2>Change password</h2>
      <form action="${ctx}/profile" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="action" value="password">
        <div class="mb-3"><label for="currentPassword" class="form-label">Current password</label>
          <input type="password" class="form-control" id="currentPassword" name="currentPassword" required><div class="invalid-feedback">Enter your current password.</div></div>
        <div class="mb-3"><label for="newPassword" class="form-label">New password</label>
          <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required><div class="invalid-feedback">Use at least 6 characters.</div></div>
        <div class="mb-3"><label for="confirmPassword" class="form-label">Confirm new password</label>
          <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required><div class="invalid-feedback">Passwords do not match.</div></div>
        <button type="submit" class="btn btn-orange">Update password</button>
      </form>
    </div>
  </div>
</div>
<%@ include file="includes/footer.jsp" %>
