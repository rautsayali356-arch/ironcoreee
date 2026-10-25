<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Classes and trainers"/><c:set var="active" value="classes"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- Data from SiteServlet: timetable (className, dayOfWeek, startTime, trainerName), trainers (name, speciality, instagram, bio) --%>
<section class="section">
  <div class="container">
    <h2>Class timetable</h2>
    <p class="lead-muted">All classes are included in every plan.</p>
    <div class="table-responsive box p-2"><table class="table align-middle mb-0">
      <thead><tr><th>Day</th><th>Time</th><th>Class</th><th>Trainer</th></tr></thead>
      <tbody>
        <c:forEach var="c" items="${timetable}"><tr><td>${c.dayOfWeek}</td><td><fmt:formatDate value="${c.startTime}" pattern="hh:mm a"/></td><td><c:out value="${c.className}"/></td><td><c:out value="${c.trainerName}"/></td></tr></c:forEach>
        <c:if test="${empty timetable}"><tr><td colspan="4" class="text-secondary">Timetable coming soon.</td></tr></c:if>
      </tbody></table></div>
  </div>
</section>
<section class="section section-alt">
  <div class="container">
    <h2>Meet the trainers</h2>
    <div class="row g-3 mt-1">
      <c:forEach var="t" items="${trainers}">
        <div class="col-12 col-md-4"><div class="box">
          <h3><c:out value="${t.name}"/></h3>
          <div class="text-warning mb-2"><c:out value="${t.speciality}"/></div>
          <p class="text-secondary"><c:out value="${t.bio}"/></p>
          <c:if test="${not empty t.instagram}"><a href="https://instagram.com/${t.instagram}" target="_blank" rel="noopener">@<c:out value="${t.instagram}"/> on Instagram</a></c:if>
        </div></div>
      </c:forEach>
    </div>
  </div>
</section>
<%@ include file="inc/siteFooter.jsp" %>
