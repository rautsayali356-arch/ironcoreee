<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Members"/><c:set var="active" value="members"/>
<%@ include file="includes/header.jsp" %>
<%--
  Data expected from MemberServlet (GET /members):
   members -> List of members: memberId, fullName, phone, email, gender, address, joiningDate, status ("Active"/"Expired")
  Actions:  Add  -> GET  /member?action=new
            Edit -> GET  /member?action=edit&id=X
            Delete -> POST /member (action=delete, id=X)
--%>
<div class="page-head"><h1>Members</h1>
  <a href="${ctx}/member?action=new" class="btn btn-orange"><i class="bi bi-person-plus me-1"></i>Add member</a></div>

<div class="card-box">
  <div class="row g-2 mb-3"><div class="col-12 col-md-5 col-lg-4">
    <div class="input-group"><span class="input-group-text bg-transparent border-secondary text-secondary"><i class="bi bi-search"></i></span>
    <input type="search" class="form-control" placeholder="Search by name, phone or email" aria-label="Search members" data-search-table="memberTable"></div>
  </div></div>
  <div class="table-responsive"><table class="table table-dark-gym table-hover" id="memberTable">
    <thead><tr><th>ID</th><th>Name</th><th>Phone</th><th>Email</th><th>Gender</th><th>Joined</th><th>Status</th><th class="text-end">Actions</th></tr></thead>
    <tbody>
      <c:forEach var="m" items="${members}">
        <tr data-row>
          <td>${m.memberId}</td>
          <td><c:out value="${m.fullName}"/></td>
          <td><c:out value="${m.phone}"/></td>
          <td><c:out value="${m.email}"/></td>
          <td><c:out value="${empty m.gender ? '-' : m.gender}"/></td>
          <td>${m.joiningDate}</td>
          <td><span class="badge-status ${m.status eq 'Active' ? 'st-active' : (m.status eq 'Pending' ? 'st-pending' : 'st-expired')}"><c:out value="${m.status}"/></span></td>
          <td class="text-end text-nowrap">
            <a href="${ctx}/member?action=edit&id=${m.memberId}" class="btn btn-sm btn-ghost" aria-label="Edit ${m.fullName}"><i class="bi bi-pencil"></i></a>
            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-url="${ctx}/member" data-id="${m.memberId}" data-name="${fn:escapeXml(m.fullName)}" aria-label="Delete ${m.fullName}"><i class="bi bi-trash"></i></button>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div>
  <c:if test="${empty members}"><div class="empty">No members found. Click <strong>Add member</strong> to register one.</div></c:if>
  <div class="empty" id="noResults" hidden>No members match your search.</div>
</div>
<%@ include file="includes/footer.jsp" %>
