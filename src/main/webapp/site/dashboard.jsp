<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My account"/><c:set var="active" value="account"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- Data from MemberServlet: m (fullName, planName, expiryDate, daysLeft, memberId...), payments --%>
<c:if test="${empty sessionScope.member}"><c:redirect url="/site/login"/></c:if>
<section class="section">
  <div class="container">
    <h2>Hi, <c:out value="${m.fullName}"/></h2>
    <div class="row g-3 mt-1">
      <div class="col-12 col-md-7"><div class="box">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
          <div><div class="text-secondary">Your plan</div><h3 class="mb-0"><c:out value="${empty m.planName ? 'No plan yet' : m.planName}"/></h3></div>
          <c:choose>
            <c:when test="${empty m.expiryDate}"><span class="badge-status st-inactive">Awaiting payment</span></c:when>
            <c:when test="${m.daysLeft < 0}"><span class="badge-status st-expired">Expired</span></c:when>
            <c:otherwise><span class="badge-status st-active">Active</span></c:otherwise>
          </c:choose>
        </div>
        <hr>
        <div class="row">
          <div class="col-6"><div class="text-secondary">Joined</div>${m.joiningDate}</div>
          <div class="col-6"><div class="text-secondary">Expires</div>
            <c:choose><c:when test="${empty m.expiryDate}">Not active yet</c:when><c:otherwise>${m.expiryDate} (${m.daysLeft >= 0 ? m.daysLeft : 0} days left)</c:otherwise></c:choose></div>
        </div>
        <c:if test="${empty m.expiryDate}"><p class="text-warning mt-3 mb-0">Pay by UPI or cash at the front desk to activate your plan.</p></c:if>
        <a class="btn btn-orange mt-3" href="${ctx}/site/plans">Renew or change plan</a>
      </div></div>
      <div class="col-12 col-md-5"><div class="box text-center">
        <div class="text-secondary mb-2">Show this at the front desk</div>
        <img alt="Check-in QR code" width="180" height="180" class="bg-white p-2 rounded" src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=GYM-${m.memberId}">
        <div class="mt-2 fw-semibold">Member ID: ${m.memberId}</div>
      </div></div>
    </div>
    <h3 class="mt-4">Payment history</h3>
    <div class="table-responsive box p-2"><table class="table align-middle mb-0">
      <thead><tr><th>ID</th><th>Plan</th><th>Amount</th><th>Date</th><th>Method</th><th>Status</th></tr></thead>
      <tbody>
        <c:forEach var="p" items="${payments}"><tr><td>${p.paymentId}</td><td><c:out value="${p.planName}"/></td><td>&#8377;<fmt:formatNumber value="${p.amount}" maxFractionDigits="0"/></td><td>${p.paymentDate}</td><td>${p.paymentMethod}</td>
          <td><span class="badge-status ${p.paymentStatus eq 'Paid' ? 'st-paid' : (p.paymentStatus eq 'Failed' ? 'st-failed' : 'st-pending')}">${p.paymentStatus}</span></td></tr></c:forEach>
        <c:if test="${empty payments}"><tr><td colspan="6" class="text-secondary">No payments yet.</td></tr></c:if>
      </tbody></table></div>
  </div>
</section>
<%@ include file="inc/siteFooter.jsp" %>
