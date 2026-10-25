<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Member login"/><c:set var="active" value="login"/>
<%@ include file="inc/siteHeader.jsp" %>
<section class="section">
  <div class="container" style="max-width:460px">
    <h2>Member login</h2>
    <c:if test="${not empty param.out}"><div class="alert alert-success">You have been logged out.</div></c:if>
    <div class="box">
      <form action="${ctx}/site/login" method="post" class="needs-validation" novalidate>
        <div class="mb-3"><label class="form-label" for="email">Email</label><input class="form-control" id="email" name="email" type="email" value="<c:out value='${param.email}'/>" required autofocus><div class="invalid-feedback">Enter your email.</div></div>
        <div class="mb-3"><label class="form-label" for="password">Password</label><input class="form-control" id="password" name="password" type="password" required><div class="invalid-feedback">Enter your password.</div></div>
        <button class="btn btn-orange w-100" type="submit">Log in</button>
      </form>
    </div>
    <p class="mt-3 text-secondary">New here? <a href="${ctx}/site/register">Join the gym</a></p>
  </div>
</section>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var f = document.querySelector('form.needs-validation');
    f.addEventListener('submit', function (e) { if (!f.checkValidity()) { e.preventDefault(); e.stopPropagation(); } f.classList.add('was-validated'); });
  });
</script>
<%@ include file="inc/siteFooter.jsp" %>
