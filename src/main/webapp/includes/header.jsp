<%-- Reusable header: auth guard + <head> + sidebar + navbar + flash messages.
     Each page must declare the JSTL taglibs and set pageTitle and active BEFORE including this file. --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- Only logged-in admins may see pages. LoginServlet must set session attribute "admin". --%>
<c:if test="${empty sessionScope.admin}"><c:redirect url="/login.jsp"/></c:if>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${pageTitle} | IronCore Gym</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="layout">
  <%@ include file="sidebar.jsp" %>
  <div class="main">
    <%@ include file="navbar.jsp" %>
    <main class="content">
      <%-- Flash messages: servlets set session "success"/"error" before redirecting, or request "error" when forwarding --%>
      <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert"><i class="bi bi-check-circle me-2"></i><c:out value="${sessionScope.success}"/><button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button></div>
        <c:remove var="success" scope="session"/>
      </c:if>
      <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${sessionScope.error}"/><button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button></div>
        <c:remove var="error" scope="session"/>
      </c:if>
      <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert"><i class="bi bi-exclamation-triangle me-2"></i><c:out value="${requestScope.error}"/><button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button></div>
      </c:if>
