<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Join the gym"/><c:set var="active" value="register"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- MemberServlet forwards here with request attribute "plans". Posts to /site/register. ?plan=ID preselects a plan. --%>
<c:set var="chosen" value="${empty param.planId ? param.plan : param.planId}"/>
<section class="section">
  <div class="container" style="max-width:640px">
    <h2>Join the crew</h2>
    <p class="lead-muted">Already a member? <a href="${ctx}/site/login">Log in</a></p>
    <div class="box">
      <form action="${ctx}/site/register" method="post" class="needs-validation" novalidate>
        <div class="mb-3"><label class="form-label" for="fullName">Full name *</label><input class="form-control" id="fullName" name="fullName" value="<c:out value='${param.fullName}'/>" minlength="3" maxlength="100" required><div class="invalid-feedback">Enter your full name.</div></div>
        <div class="row g-3 mb-3">
          <div class="col-md-6"><label class="form-label" for="phone">Phone *</label><input class="form-control" id="phone" name="phone" type="tel" value="<c:out value='${param.phone}'/>" pattern="[6-9][0-9]{9}" maxlength="10" required><div class="invalid-feedback">Enter a valid 10-digit number.</div></div>
          <div class="col-md-6"><label class="form-label" for="email">Email *</label><input class="form-control" id="email" name="email" type="email" value="<c:out value='${param.email}'/>" required><div class="invalid-feedback">Enter a valid email.</div></div>
        </div>
        <div class="row g-3 mb-3">
          <div class="col-md-6"><label class="form-label" for="password">Password *</label><input class="form-control" id="password" name="password" type="password" minlength="6" required><div class="invalid-feedback">At least 6 characters.</div></div>
          <div class="col-md-6"><label class="form-label" for="confirmPassword">Confirm password *</label><input class="form-control" id="confirmPassword" name="confirmPassword" type="password" required><div class="invalid-feedback">Passwords must match.</div></div>
        </div>
        <div class="row g-3 mb-3">
          <div class="col-md-6"><label class="form-label" for="gender">Gender (optional)</label><select class="form-select" id="gender" name="gender"><option value="">Prefer not to say</option><option ${param.gender eq 'Male' ? 'selected' : ''}>Male</option><option ${param.gender eq 'Female' ? 'selected' : ''}>Female</option><option ${param.gender eq 'Other' ? 'selected' : ''}>Other</option></select></div>
          <div class="col-md-6"><label class="form-label" for="planId">Plan *</label>
            <select class="form-select" id="planId" name="planId" required><option value="">Choose a plan</option>
              <c:forEach var="p" items="${plans}"><option value="${p.planId}" ${chosen eq p.planId ? 'selected' : ''}><c:out value="${p.planName}"/> - &#8377;<fmt:formatNumber value="${p.fee}" maxFractionDigits="0"/></option></c:forEach>
            </select><div class="invalid-feedback">Pick a plan.</div></div>
        </div>
        <div class="form-check mb-3"><input class="form-check-input" type="checkbox" id="terms" required><label class="form-check-label" for="terms">I agree to the gym rules. Student plan members must show a college ID.</label></div>
        <button class="btn btn-orange w-100 btn-lg" type="submit">Create my account</button>
        <p class="small text-secondary mt-3 mb-0">You pay by UPI or cash at the front desk. Your plan goes active once the desk confirms it.</p>
      </form>
    </div>
  </div>
</section>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var f = document.querySelector('form.needs-validation');
    f.addEventListener('submit', function (e) {
      var pw = f.password, cf = f.confirmPassword;
      cf.setCustomValidity(pw.value === cf.value ? '' : 'Passwords do not match');
      if (!f.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
      f.classList.add('was-validated');
    });
  });
</script>
<%@ include file="inc/siteFooter.jsp" %>
