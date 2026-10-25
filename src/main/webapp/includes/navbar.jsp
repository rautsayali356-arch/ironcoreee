<header class="topbar">
  <div class="d-flex align-items-center gap-3">
    <button class="btn btn-ghost d-lg-none" id="menuToggle" aria-label="Open menu"><i class="bi bi-list fs-5"></i></button>
    <h2 class="page-name">${pageTitle}</h2>
  </div>
  <div class="dropdown">
    <button class="btn btn-ghost d-flex align-items-center gap-2" data-bs-toggle="dropdown" aria-expanded="false">
      <span class="avatar">${not empty sessionScope.admin.fullName ? sessionScope.admin.fullName.substring(0,1) : 'A'}</span>
      <span class="d-none d-sm-inline"><c:out value="${sessionScope.admin.fullName}"/></span>
    </button>
    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark">
      <li><a class="dropdown-item" href="${ctx}/profile"><i class="bi bi-person me-2"></i>My profile</a></li>
      <li><hr class="dropdown-divider"></li>
      <li><button class="dropdown-item text-danger" data-bs-toggle="modal" data-bs-target="#logoutModal"><i class="bi bi-box-arrow-right me-2"></i>Log out</button></li>
    </ul>
  </div>
</header>
