// Gym Management System - client-side helpers
document.addEventListener('DOMContentLoaded', () => {

  // 1. Sidebar toggle (mobile/tablet)
  const toggle = document.getElementById('menuToggle');
  if (toggle) toggle.addEventListener('click', () => document.body.classList.toggle('sidebar-open'));
  document.addEventListener('click', e => {
    if (document.body.classList.contains('sidebar-open') && !e.target.closest('.sidebar') && !e.target.closest('#menuToggle'))
      document.body.classList.remove('sidebar-open');
  });

  // 2. Bootstrap form validation
  document.querySelectorAll('form.needs-validation').forEach(form => {
    form.addEventListener('submit', e => {
      const pw = form.querySelector('[name=newPassword]'), cf = form.querySelector('[name=confirmPassword]');
      if (pw && cf) cf.setCustomValidity(pw.value === cf.value ? '' : 'Passwords do not match');
      if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
      form.classList.add('was-validated');
    });
  });

  // 3. Live table search: <input data-search-table="tableId">
  document.querySelectorAll('[data-search-table]').forEach(input => {
    const rows = () => document.querySelectorAll('#' + input.dataset.searchTable + ' tbody tr[data-row]');
    input.addEventListener('input', () => {
      const q = input.value.trim().toLowerCase();
      let shown = 0;
      rows().forEach(r => { const ok = r.textContent.toLowerCase().includes(q); r.hidden = !ok; if (ok) shown++; });
      const none = document.getElementById('noResults');
      if (none) none.hidden = shown !== 0;
    });
  });

  // 4. Delete confirmation modal (buttons carry data-url, data-id, data-name)
  const delModal = document.getElementById('deleteModal');
  if (delModal) delModal.addEventListener('show.bs.modal', e => {
    const b = e.relatedTarget;
    delModal.querySelector('#deleteForm').action = b.dataset.url;
    delModal.querySelector('#deleteId').value = b.dataset.id;
    delModal.querySelector('#deleteName').textContent = b.dataset.name;
  });

  // 5. Auto-fill payment amount from selected plan
  const planSel = document.getElementById('planId'), amount = document.getElementById('amount');
  if (planSel && amount) planSel.addEventListener('change', () => {
    const fee = planSel.selectedOptions[0].dataset.fee;
    if (fee) amount.value = fee;
  });

  // 6. Default today's date on empty date inputs marked data-default-today
  document.querySelectorAll('input[data-default-today]').forEach(i => { if (!i.value) i.value = new Date().toISOString().slice(0, 10); });

  // 7. Auto-dismiss success alerts
  document.querySelectorAll('.alert-success').forEach(a => setTimeout(() => bootstrap.Alert.getOrCreateInstance(a).close(), 5000));
});
