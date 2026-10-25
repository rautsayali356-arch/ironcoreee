<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="g" value="${empty member ? param.gender : member.gender}"/><c:set var="pageTitle" value="${empty member ? 'Add Member' : 'Edit Member'}"/><c:set var="active" value="members"/>
<%@ include file="includes/header.jsp" %>
<%--
  MemberServlet forwards here. If request attribute "member" exists the form is in EDIT mode (pre-filled).
  Submits POST /member with action=add or action=update.
  Member ID is AUTO_INCREMENT in MySQL, so it is shown read-only when editing.
--%>
<div class="page-head"><h1>${empty member ? 'Register new member' : 'Edit member'}</h1>
  <a href="${ctx}/members" class="btn btn-ghost"><i class="bi bi-arrow-left me-1"></i>Back to members</a></div>

<div class="card-box">
  <form action="${ctx}/member" method="post" class="needs-validation" novalidate>
    <input type="hidden" name="action" value="${empty member ? 'add' : 'update'}">
    <c:if test="${not empty member}"><input type="hidden" name="memberId" value="${member.memberId}"></c:if>
    <div class="row g-3">
      <c:if test="${not empty member}"><div class="col-md-3"><label class="form-label">Member ID</label><input class="form-control" value="${member.memberId}" readonly></div></c:if>
      <div class="col-md-${empty member ? 6 : 9}">
        <label for="fullName" class="form-label">Full name *</label>
        <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${empty member ? param.fullName : member.fullName}'/>" minlength="3" maxlength="100" pattern="[A-Za-z .'-]+" required>
        <div class="invalid-feedback">Enter a valid name (letters only, minimum 3 characters).</div>
      </div>
      <div class="col-md-6">
        <label for="phone" class="form-label">Phone number *</label>
        <input type="tel" class="form-control" id="phone" name="phone" value="<c:out value='${empty member ? param.phone : member.phone}'/>" pattern="[6-9][0-9]{9}" maxlength="10" placeholder="10-digit mobile number" required>
        <div class="invalid-feedback">Enter a valid 10-digit phone number.</div>
      </div>
      <div class="col-md-6">
        <label for="email" class="form-label">Email *</label>
        <input type="email" class="form-control" id="email" name="email" value="<c:out value='${empty member ? param.email : member.email}'/>" maxlength="100" required>
        <div class="invalid-feedback">Enter a valid email address.</div>
      </div>
      <div class="col-md-6">
        <label for="gender" class="form-label">Gender <span class="text-secondary">(optional)</span></label>
        <select class="form-select" id="gender" name="gender">
          <option value="">Select gender</option>
          <option value="Male" ${g eq 'Male' ? 'selected' : ''}>Male</option>
          <option value="Female" ${g eq 'Female' ? 'selected' : ''}>Female</option>
          <option value="Other" ${g eq 'Other' ? 'selected' : ''}>Other</option>
        </select>
      </div>
      <div class="col-md-6">
        <label for="joiningDate" class="form-label">Joining date *</label>
        <input type="date" class="form-control" id="joiningDate" name="joiningDate" value="${empty member ? param.joiningDate : member.joiningDate}" data-default-today required>
        <div class="invalid-feedback">Select the joining date.</div>
      </div>
      <div class="col-12">
        <label for="address" class="form-label">Address <span class="text-secondary">(optional)</span></label>
        <textarea class="form-control" id="address" name="address" rows="3" maxlength="255"><c:out value="${empty member ? param.address : member.address}"/></textarea>
      </div>
    </div>
    <div class="mt-4 d-flex gap-2">
      <button type="submit" class="btn btn-orange"><i class="bi bi-check-lg me-1"></i>${empty member ? 'Save member' : 'Update member'}</button>
      <a href="${ctx}/members" class="btn btn-ghost">Cancel</a>
    </div>
  </form>
</div>
<%@ include file="includes/footer.jsp" %>
