<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Payments"/><c:set var="active" value="payments"/>
<%@ include file="includes/header.jsp" %>
<%--
  Data expected from PaymentServlet (GET /payments):
   payments -> List: paymentId, memberName, planName, amount, paymentDate, paymentMethod, paymentStatus ("Paid"/"Pending"/"Failed")
  Optional: ?memberId=X lets the servlet return only one member's payment history.
--%>
<div class="page-head"><h1>Payment records</h1>
  <a href="${ctx}/payment?action=new" class="btn btn-orange"><i class="bi bi-plus-lg me-1"></i>Record payment</a></div>

<div class="card-box">
  <div class="row g-2 mb-3"><div class="col-12 col-md-5 col-lg-4">
    <div class="input-group"><span class="input-group-text bg-transparent border-secondary text-secondary"><i class="bi bi-search"></i></span>
    <input type="search" class="form-control" placeholder="Search member, plan or method" aria-label="Search payments" data-search-table="paymentTable"></div>
  </div></div>
  <div class="table-responsive"><table class="table table-dark-gym table-hover" id="paymentTable">
    <thead><tr><th>ID</th><th>Member</th><th>Plan</th><th>Amount</th><th>Date</th><th>Method</th><th>Status</th><th class="text-end">Actions</th></tr></thead>
    <tbody>
      <c:forEach var="p" items="${payments}">
        <tr data-row>
          <td>${p.paymentId}</td>
          <td><c:out value="${p.memberName}"/></td>
          <td><c:out value="${p.planName}"/></td>
          <td>&#8377;<fmt:formatNumber value="${p.amount}" maxFractionDigits="2"/></td>
          <td>${p.paymentDate}</td>
          <td><c:out value="${p.paymentMethod}"/></td>
          <td><span class="badge-status st-${fn:toLowerCase(p.paymentStatus)}"><c:out value="${p.paymentStatus}"/></span></td>
          <td class="text-end text-nowrap">
            <c:if test="${p.paymentStatus ne 'Paid'}"><form action="${ctx}/payment" method="post" class="d-inline"><input type="hidden" name="action" value="markPaid"><input type="hidden" name="id" value="${p.paymentId}"><button class="btn btn-sm btn-ghost" type="submit" title="Mark as paid"><i class="bi bi-check2-circle"></i> Mark paid</button></form></c:if>
            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-url="${ctx}/payment" data-id="${p.paymentId}" data-name="payment #${p.paymentId} (${fn:escapeXml(p.memberName)})" aria-label="Delete payment ${p.paymentId}"><i class="bi bi-trash"></i></button>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div>
  <c:if test="${empty payments}"><div class="empty">No payments recorded yet.</div></c:if>
  <div class="empty" id="noResults" hidden>No payments match your search.</div>
</div>
<%@ include file="includes/footer.jsp" %>
