<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Train hard. Pay honest."/><c:set var="active" value="home"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- Data from SiteServlet: plans (planId, planName, durationMonths, fee, description, tag) --%>
<%-- Drop a real photo of your members at assets/img/hero.jpg - it appears behind the headline automatically. --%>
<section class="hero" style="background-image:linear-gradient(rgba(20,20,20,.7),#141414),url('${ctx}/assets/img/hero.jpg')">
  <div class="container">
    <h1>Train hard.<br>Pay honest.<br>Bring your crew.</h1>
    <p>Real prices on the page, no lock-in on monthly plans, and coaches who know your name.</p>
    <div class="d-flex flex-wrap gap-2 mt-4">
      <a class="btn btn-orange btn-lg" href="${ctx}/site/register">Join now</a>
      <a class="btn btn-line btn-lg" href="${ctx}/site/contact?interest=Free+trial">Book a free trial</a>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <h2>What does it cost?</h2>
    <p class="lead-muted">Every price is shown up front. <a href="${ctx}/site/plans">See all plans</a></p>
    <div class="row g-3">
      <c:forEach var="p" items="${plans}" begin="0" end="2">
        <div class="col-12 col-md-4"><div class="plan ${p.tag eq 'Most popular' ? 'plan-hot' : ''}">
          <c:if test="${not empty p.tag}"><span class="tag ${p.tag eq 'Most popular' ? 'tag-hot' : ''}"><c:out value="${p.tag}"/></span></c:if>
          <h3><c:out value="${p.planName}"/></h3>
          <div class="price">&#8377;<fmt:formatNumber value="${p.fee}" maxFractionDigits="0"/></div>
          <div class="per">&#8377;<fmt:formatNumber value="${p.fee / p.durationMonths}" maxFractionDigits="0"/> per month</div>
          <a class="btn btn-line mt-2" href="${ctx}/site/register?plan=${p.planId}">Choose plan</a>
        </div></div>
      </c:forEach>
      <c:if test="${empty plans}"><div class="col-12"><div class="box">Plans will appear here once they are added in the admin panel.</div></div></c:if>
    </div>
  </div>
</section>

<section class="section section-alt">
  <div class="container">
    <h2>How to join</h2>
    <div class="row g-4"><div class="col-md-7">
      <ol class="steps">
        <li><div><strong>Create your account.</strong><br><span class="text-secondary">Pick a plan and sign up in under a minute.</span></div></li>
        <li><div><strong>Pay by UPI or cash at the front desk.</strong><br><span class="text-secondary">Your plan turns active as soon as the desk confirms it.</span></div></li>
        <li><div><strong>Show your QR code and train.</strong><br><span class="text-secondary">Find it in My account on your phone.</span></div></li>
      </ol></div>
      <div class="col-md-5"><div class="box"><h3>Not sure yet?</h3><p class="text-secondary">Try a free day or a 3-day pass before you commit.</p>
        <a class="btn btn-orange" href="${ctx}/site/contact?interest=Free+trial">Get a free trial</a></div></div></div>
  </div>
</section>
<%@ include file="inc/siteFooter.jsp" %>
