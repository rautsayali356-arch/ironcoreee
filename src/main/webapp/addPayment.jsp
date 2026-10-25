<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Record Payment"/><c:set var="active" value="payments"/>
<%@ include file="includes/header.jsp" %>
<%--
  PaymentServlet (action=new) must set request attributes before forwarding here:
   members -> List (memberId, fullName)        plans -> List (planId, planName, fee, durationMonths)
  Submits POST /payment with action=add.
--%>
<div class="page-head"><h1>Record a payment</h1>
  <a href="${ctx}/payments" class="btn btn-ghost"><i class="bi bi-arrow-left me-1"></i>Back to payments</a></div>

<div class="card-box">
  <form action="${ctx}/payment" method="post" class="needs-validation" novalidate>
    <input type="hidden" name="action" value="add">
    <div class="row g-3">
      <div class="col-md-6">
        <label for="memberId" class="form-label">Member *</label>
        <select class="form-select" id="memberId" name="memberId" required>
          <option value="">Select member</option>
          <c:forEach var="m" items="${members}"><option value="${m.memberId}"><c:out value="${m.fullName}"/> (ID ${m.memberId})</option></c:forEach>
        </select>
        <div class="invalid-feedback">Please select a member.</div>
      </div>
      <div class="col-md-6">
        <label for="planId" class="form-label">Membership plan *</label>
        <select class="form-select" id="planId" name="planId" required>
          <option value="">Select plan</option>
          <c:forEach var="p" items="${plans}"><option value="${p.planId}" data-fee="${p.fee}"><c:out value="${p.planName}"/> - &#8377;${p.fee} / ${p.durationMonths} mo</option></c:forEach>
        </select>
        <div class="invalid-feedback">Please select a plan.</div>
      </div>
      <div class="col-md-4">
        <label for="amount" class="form-label">Amount (&#8377;) *</label>
        <input type="number" class="form-control" id="amount" name="amount" min="1" step="0.01" required>
        <div class="invalid-feedback">Enter an amount greater than 0.</div>
      </div>
      <div class="col-md-4">
        <label for="paymentDate" class="form-label">Payment date *</label>
        <input type="date" class="form-control" id="paymentDate" name="paymentDate" data-default-today required>
        <div class="invalid-feedback">Select the payment date.</div>
      </div>
      <div class="col-md-4">
        <label for="paymentMethod" class="form-label">Payment method *</label>
        <select class="form-select" id="paymentMethod" name="paymentMethod" required>
          <option value="">Select method</option><option>Cash</option><option>UPI</option><option>Card</option><option>Net Banking</option>
        </select>
        <div class="invalid-feedback">Choose a payment method.</div>
      </div>
      <div class="col-md-4">
        <label for="paymentStatus" class="form-label">Payment status *</label>
        <select class="form-select" id="paymentStatus" name="paymentStatus" required>
          <option value="Paid" selected>Paid</option><option value="Pending">Pending</option><option value="Failed">Failed</option>
        </select>
      </div>
    </div>
    <div class="mt-4 d-flex gap-2">
      <button type="submit" class="btn btn-orange"><i class="bi bi-check-lg me-1"></i>Save payment</button>
      <a href="${ctx}/payments" class="btn btn-ghost">Cancel</a>
    </div>
  </form>
</div>
<%@ include file="includes/footer.jsp" %>
