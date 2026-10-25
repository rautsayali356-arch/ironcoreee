<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Something went wrong | IronCore Gym</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"><link href="${ctx}/assets/css/site.css" rel="stylesheet"></head>
<body><div class="container text-center py-5" style="max-width:560px;padding-bottom:0">
  <div class="brand mb-4" style="font-size:2rem">Iron<span>Core</span></div>
  <h1 class="mb-2">Oops, that did not work</h1>
  <p class="text-secondary">The page you asked for was not found, or something went wrong on our side. Please try again.</p>
  <a class="btn btn-orange mt-2" href="${ctx}/site/home">Back to home</a>
</div></body></html>
