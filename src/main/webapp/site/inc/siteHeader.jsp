<%-- Shared top of every public page. Pages set pageTitle and active, and declare the JSTL taglibs, before including this. --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- ====== EDIT YOUR GYM DETAILS HERE (used on every public page) ====== --%>
<c:set var="gymName" value="IronCore Gym"/>
<c:set var="waNumber" value="919999999999"/>   <%-- country code + number, no "+" or spaces --%>
<c:set var="gymPhone" value="+91 99999 99999"/>
<c:set var="gymEmail" value="hello@ironcoregym.example"/>
<c:set var="gymAddress" value="Your street, Your city, Your state"/>
<c:set var="gymHours" value="Mon-Sat 5:30 AM to 10:30 PM, Sun 7 AM to 12 PM"/>
<c:set var="igHandle" value="ironcoregym"/>
<%-- =================================================================== --%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${pageTitle} | ${gymName}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;800&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${ctx}/assets/css/site.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-md navbar-dark site-nav sticky-top">
  <div class="container">
    <a class="navbar-brand brand" href="${ctx}/site/home">Iron<span>Core</span></a>
    <a class="btn btn-orange btn-sm ms-auto me-2 d-md-none" href="${ctx}/site/register">Join now</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#siteNav" aria-controls="siteNav" aria-expanded="false" aria-label="Open menu"><span class="navbar-toggler-icon"></span></button>
    <div class="collapse navbar-collapse" id="siteNav">
      <ul class="navbar-nav ms-auto align-items-md-center gap-md-1">
        <li class="nav-item"><a class="nav-link ${active eq 'home' ? 'active' : ''}" href="${ctx}/site/home">Home</a></li>
        <li class="nav-item"><a class="nav-link ${active eq 'plans' ? 'active' : ''}" href="${ctx}/site/plans">Plans</a></li>
        <li class="nav-item"><a class="nav-link ${active eq 'classes' ? 'active' : ''}" href="${ctx}/site/classes">Classes</a></li>
        <li class="nav-item"><a class="nav-link ${active eq 'contact' ? 'active' : ''}" href="${ctx}/site/contact">Contact</a></li>
        <c:choose>
          <c:when test="${not empty sessionScope.member}">
            <li class="nav-item"><a class="nav-link ${active eq 'account' ? 'active' : ''}" href="${ctx}/site/dashboard">My account</a></li>
            <li class="nav-item"><a class="nav-link" href="${ctx}/site/logout">Log out</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="nav-link ${active eq 'login' ? 'active' : ''}" href="${ctx}/site/login">Log in</a></li>
            <li class="nav-item d-none d-md-block"><a class="btn btn-orange ms-md-2" href="${ctx}/site/register">Join now</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
<main>
<div class="container pt-3">
  <c:if test="${not empty sessionScope.success}"><div class="alert alert-success alert-dismissible fade show" role="alert"><c:out value="${sessionScope.success}"/><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="success" scope="session"/></c:if>
  <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger alert-dismissible fade show" role="alert"><c:out value="${sessionScope.error}"/><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="error" scope="session"/></c:if>
  <c:if test="${not empty requestScope.error}"><div class="alert alert-danger" role="alert"><c:out value="${requestScope.error}"/></div></c:if>
</div>
