<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Plans and pricing"/><c:set var="active" value="plans"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- Data from SiteServlet: plans. Add/edit plans in the admin panel (or the plans table) and they appear here. --%>
<section class="section">
  <div class="container">
    <h2>Plans and pricing</h2>
    <p class="lead-muted">No hidden fees. Monthly plans have no lock-in. Longer plans cost less per month.</p>
    <div class="row g-3">
      <c:forEach var="p" items="${plans}">
        <div class="col-12 col-md-6 col-lg-4"><div class="plan ${p.tag eq 'Most popular' ? 'plan-hot' : ''}">
          <c:if test="${not empty p.tag}"><span class="tag ${p.tag eq 'Most popular' ? 'tag-hot' : ''}"><c:out value="${p.tag}"/></span></c:if>
          <h3><c:out value="${p.planName}"/></h3>
          <div class="price">&#8377;<fmt:formatNumber value="${p.fee}" maxFractionDigits="0"/></div>
          <div class="per">&#8377;<fmt:formatNumber value="${p.fee / p.durationMonths}" maxFractionDigits="0"/> per month &middot; ${p.durationMonths} month${p.durationMonths > 1 ? 's' : ''} total</div>
          <p class="mt-2 flex-grow-1"><c:out value="${p.description}"/></p>
          <c:choose>
            <c:when test="${not empty sessionScope.member}"><form action="${ctx}/site/renew" method="post" class="d-grid"><input type="hidden" name="planId" value="${p.planId}"><button class="btn ${p.tag eq 'Most popular' ? 'btn-orange' : 'btn-line'}" type="submit">Choose <c:out value="${p.planName}"/></button></form></c:when>
            <c:otherwise><a class="btn ${p.tag eq 'Most popular' ? 'btn-orange' : 'btn-line'}" href="${ctx}/site/register?plan=${p.planId}">Choose <c:out value="${p.planName}"/></a></c:otherwise>
          </c:choose>
        </div></div>
      </c:forEach>
    </div>
    <c:if test="${empty plans}"><div class="box">No plans yet. Add some in the admin panel.</div></c:if>
    <div class="row g-3 mt-3">
      <div class="col-md-6"><div class="box"><h3>How payment works</h3>
        <ol class="steps"><li><div>Sign up and choose your plan.</div></li><li><div>Pay by UPI or cash at the front desk.</div></li><li><div>The desk confirms it and your plan goes active.</div></li></ol></div></div>
      <div class="col-md-6"><div class="box"><h3>Try before you join</h3><p class="text-secondary">Ask for a free trial day or a 3-day pass.</p>
        <a class="btn btn-orange" href="${ctx}/site/contact?interest=Free+trial">Get a free trial</a></div></div>
    </div>
  </div>
</section>
<%@ include file="inc/siteFooter.jsp" %>
