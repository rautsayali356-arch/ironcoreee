<%-- Reusable footer: closes layout, adds shared modals and scripts. --%>
    </main>
    <footer class="site-footer">&copy; 2026 IronCore Gym Management System &middot; Full Stack Java Mini Project</footer>
  </div>
</div>

<!-- Delete confirmation modal (shared by members, plans, payments) -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered"><div class="modal-content">
    <form id="deleteForm" method="post">
      <input type="hidden" name="action" value="delete">
      <input type="hidden" name="id" id="deleteId">
      <div class="modal-header"><h5 class="modal-title"><i class="bi bi-trash text-danger me-2"></i>Confirm delete</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button></div>
      <div class="modal-body">Are you sure you want to delete <strong id="deleteName"></strong>? This cannot be undone.</div>
      <div class="modal-footer"><button type="button" class="btn btn-ghost" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-danger">Yes, delete</button></div>
    </form>
  </div></div>
</div>

<!-- Logout confirmation modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title"><i class="bi bi-box-arrow-right text-warning me-2"></i>Log out</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button></div>
    <div class="modal-body">Do you want to end your session?</div>
    <div class="modal-footer"><button type="button" class="btn btn-ghost" data-bs-dismiss="modal">Stay logged in</button><a href="${ctx}/logout" class="btn btn-orange">Log out</a></div>
  </div></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
