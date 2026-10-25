<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Membership Plans"/><c:set var="active" value="plans"/>
<%@ include file="includes/header.jsp" %>
<%--
  Data expected from PlanServlet (GET /plans):
   plans -> List of plans: planId, planName, durationMonths, fee, description
  Edit -> GET /plan?action=edit&id=X     Delete -> POST /plan (action=delete, id=X)
--%>
<div class="page-head"><h1>Membership plans</h1>
  <a href="${ctx}/plan?action=new" class="btn btn-orange"><i class="bi bi-plus-lg me-1"></i>Add plan</a></div>

<div class="row g-3">
  <c:forEach var="p" items="${plans}">
    <div class="col-12 col-md-6 col-xl-4">
      <div class="card-box plan-card">
        <div class="d-flex justify-content-between align-items-start">
          <h2 class="mb-1"><c:out value="${p.planName}"/></h2><span class="text-secondary small">ID ${p.planId}</span>
        </div>
        <div class="fee">&#8377;<fmt:formatNumber value="${p.fee}" maxFractionDigits="2"/></div>
        <div class="text-secondary mb-2">${p.durationMonths} month${p.durationMonths > 1 ? 's' : ''}</div>
        <p class="flex-grow-1"><c:out value="${empty p.description ? 'No description provided.' : p.description}"/></p>
        <div class="d-flex gap-2">
          <a href="${ctx}/plan?action=edit&id=${p.planId}" class="btn btn-sm btn-ghost flex-fill"><i class="bi bi-pencil me-1"></i>Edit</a>
          <button class="btn btn-sm btn-outline-danger flex-fill" data-bs-toggle="modal" data-bs-target="#deleteModal" data-url="${ctx}/plan" data-id="${p.planId}" data-name="${fn:escapeXml(p.planName)}"><i class="bi bi-trash me-1"></i>Delete</button>
        </div>
      </div>
    </div>
  </c:forEach>
</div>
<c:if test="${empty plans}"><div class="card-box empty">No plans yet. Click <strong>Add plan</strong> to create the first one.</div></c:if>
<%@ include file="includes/footer.jsp" %>
