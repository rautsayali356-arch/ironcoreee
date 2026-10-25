<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${empty plan ? 'Add Plan' : 'Edit Plan'}"/><c:set var="active" value="plans"/>
<%@ include file="includes/header.jsp" %>
<%-- PlanServlet forwards here. Request attribute "plan" present => edit mode. POST /plan action=add|update --%>
<div class="page-head"><h1>${empty plan ? 'Add membership plan' : 'Edit membership plan'}</h1>
  <a href="${ctx}/plans" class="btn btn-ghost"><i class="bi bi-arrow-left me-1"></i>Back to plans</a></div>

<div class="card-box">
  <form action="${ctx}/plan" method="post" class="needs-validation" novalidate>
    <input type="hidden" name="action" value="${empty plan ? 'add' : 'update'}">
    <c:if test="${not empty plan}"><input type="hidden" name="planId" value="${plan.planId}"></c:if>
    <div class="row g-3">
      <div class="col-md-6">
        <label for="planName" class="form-label">Plan name *</label>
        <input type="text" class="form-control" id="planName" name="planName" value="<c:out value='${empty plan ? param.planName : plan.planName}'/>" minlength="3" maxlength="60" placeholder="e.g. Quarterly Plan" required>
        <div class="invalid-feedback">Enter a plan name (minimum 3 characters).</div>
      </div>
      <div class="col-md-3">
        <label for="durationMonths" class="form-label">Duration (months) *</label>
        <input type="number" class="form-control" id="durationMonths" name="durationMonths" value="${empty plan ? param.durationMonths : plan.durationMonths}" min="1" max="36" step="1" required>
        <div class="invalid-feedback">Enter 1 to 36 months.</div>
      </div>
      <div class="col-md-3">
        <label for="fee" class="form-label">Fee (&#8377;) *</label>
        <input type="number" class="form-control" id="fee" name="fee" value="${empty plan ? param.fee : plan.fee}" min="1" step="0.01" required>
        <div class="invalid-feedback">Enter a fee greater than 0.</div>
      </div>
      <div class="col-md-6">
        <c:set var="tg" value="${empty plan ? param.tag : plan.tag}"/>
        <label for="tag" class="form-label">Label on the website <span class="text-secondary">(optional)</span></label>
        <select class="form-select" id="tag" name="tag"><option value="">None</option>
          <option ${tg eq 'Most popular' ? 'selected' : ''}>Most popular</option><option ${tg eq 'Student' ? 'selected' : ''}>Student</option>
          <option ${tg eq 'Buddy' ? 'selected' : ''}>Buddy</option><option ${tg eq 'Off-peak' ? 'selected' : ''}>Off-peak</option><option ${tg eq 'Try first' ? 'selected' : ''}>Try first</option></select>
      </div>
      <div class="col-12">
        <label for="description" class="form-label">Description</label>
        <textarea class="form-control" id="description" name="description" rows="3" maxlength="255" placeholder="What does this plan include?"><c:out value="${empty plan ? param.description : plan.description}"/></textarea>
      </div>
    </div>
    <div class="mt-4 d-flex gap-2">
      <button type="submit" class="btn btn-orange"><i class="bi bi-check-lg me-1"></i>${empty plan ? 'Save plan' : 'Update plan'}</button>
      <a href="${ctx}/plans" class="btn btn-ghost">Cancel</a>
    </div>
  </form>
</div>
<%@ include file="includes/footer.jsp" %>
