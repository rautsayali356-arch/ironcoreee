<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Dashboard"/><c:set var="active" value="dashboard"/>
<%@ include file="includes/header.jsp" %>
<%--
  Data expected from DashboardServlet (request attributes):
   stats           -> object/Map with totalMembers, activeMemberships, expiredMemberships, totalRevenue
   recentMembers   -> List of members (memberId, fullName, phone, joiningDate)
   recentPayments  -> List of payments (paymentId, memberName, planName, amount, paymentDate, paymentStatus)
--%>
<div class="page-head"><h1>Dashboard</h1>
  <a href="${ctx}/payment?action=new" class="btn btn-orange"><i class="bi bi-plus-lg me-1"></i>Record payment</a></div>

<div class="row g-3 mb-4">
  <div class="col-12 col-sm-6 col-xl-3"><div class="card-box stat"><div class="ico"><i class="bi bi-people"></i></div><div><div class="val">${stats.totalMembers}</div><div class="lbl">Total members</div></div></div></div>
  <div class="col-12 col-sm-6 col-xl-3"><div class="card-box stat"><div class="ico"><i class="bi bi-patch-check"></i></div><div><div class="val">${stats.activeMemberships}</div><div class="lbl">Active memberships</div></div></div></div>
  <div class="col-12 col-sm-6 col-xl-3"><div class="card-box stat"><div class="ico"><i class="bi bi-hourglass-bottom"></i></div><div><div class="val">${stats.expiredMemberships}</div><div class="lbl">Expired memberships</div></div></div></div>
  <div class="col-12 col-sm-6 col-xl-3"><div class="card-box stat"><div class="ico"><i class="bi bi-currency-rupee"></i></div><div><div class="val"><fmt:formatNumber value="${stats.totalRevenue}" type="number" maxFractionDigits="2"/></div><div class="lbl">Total revenue (&#8377;)</div></div></div></div>
</div>

<div class="row g-3">
  <div class="col-12 col-xl-6">
    <div class="card-box"><h2>Recent members</h2>
      <div class="table-responsive"><table class="table table-dark-gym table-hover">
        <thead><tr><th>ID</th><th>Name</th><th>Phone</th><th>Joined</th></tr></thead>
        <tbody>
          <c:forEach var="m" items="${recentMembers}"><tr><td>${m.memberId}</td><td><c:out value="${m.fullName}"/></td><td><c:out value="${m.phone}"/></td><td>${m.joiningDate}</td></tr></c:forEach>
          <c:if test="${empty recentMembers}"><tr><td colspan="4" class="empty">No members yet. <a href="${ctx}/member?action=new">Add the first member</a>.</td></tr></c:if>
        </tbody></table></div>
    </div>
  </div>
  <div class="col-12 col-xl-6">
    <div class="card-box"><h2>Recent payments</h2>
      <div class="table-responsive"><table class="table table-dark-gym table-hover">
        <thead><tr><th>Member</th><th>Plan</th><th>Amount</th><th>Status</th></tr></thead>
        <tbody>
          <c:forEach var="p" items="${recentPayments}"><tr><td><c:out value="${p.memberName}"/></td><td><c:out value="${p.planName}"/></td><td>&#8377;<fmt:formatNumber value="${p.amount}" maxFractionDigits="2"/></td>
            <td><span class="badge-status st-${fn:toLowerCase(p.paymentStatus)}">${p.paymentStatus}</span></td></tr></c:forEach>
          <c:if test="${empty recentPayments}"><tr><td colspan="4" class="empty">No payments recorded yet.</td></tr></c:if>
        </tbody></table></div>
    </div>
  </div>
</div>
<%@ include file="includes/footer.jsp" %>
