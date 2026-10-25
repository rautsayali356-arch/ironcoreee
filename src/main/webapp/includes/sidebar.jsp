<%-- Sidebar: links go to SERVLETS (not directly to JSPs) so data is loaded first. --%>
<aside class="sidebar" aria-label="Main navigation">
  <div class="brand"><i class="bi bi-lightning-charge-fill text-warning"></i> Iron<span>Core</span></div>
  <ul class="side-nav">
    <li><a href="${ctx}/dashboard" class="${active eq 'dashboard' ? 'active' : ''}"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="${ctx}/members" class="${active eq 'members' ? 'active' : ''}"><i class="bi bi-people"></i> Members</a></li>
    <li><a href="${ctx}/plans" class="${active eq 'plans' ? 'active' : ''}"><i class="bi bi-card-checklist"></i> Plans</a></li>
    <li><a href="${ctx}/payments" class="${active eq 'payments' ? 'active' : ''}"><i class="bi bi-cash-coin"></i> Payments</a></li>
    <li><a href="${ctx}/profile" class="${active eq 'profile' ? 'active' : ''}"><i class="bi bi-person-circle"></i> Profile</a></li>
  </ul>
  <div class="side-foot">Gym Management System</div>
</aside>
