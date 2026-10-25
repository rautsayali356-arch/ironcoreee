<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Contact and FAQ"/><c:set var="active" value="contact"/>
<%@ include file="inc/siteHeader.jsp" %>
<%-- Form posts to SiteServlet (/site/contact) which saves a row in the enquiries table. FAQ answers: edit to match your gym's real rules. --%>
<section class="section">
  <div class="container">
    <h2>Visit or message us</h2>
    <p class="lead-muted">Prefer chat? Tap the WhatsApp button and we will reply there.</p>
    <div class="row g-3">
      <div class="col-12 col-lg-6">
        <div class="box mb-3"><strong>Address</strong><br>${gymAddress}<br><br><strong>Hours</strong><br>${gymHours}<br><br><strong>Phone</strong><br>${gymPhone}</div>
        <div class="ratio ratio-16x9 rounded overflow-hidden"><iframe title="Gym location map" loading="lazy" src="https://www.google.com/maps?q=<c:out value='${gymAddress}'/>&output=embed"></iframe></div>
      </div>
      <div class="col-12 col-lg-6"><div class="box">
        <form action="${ctx}/site/contact" method="post" class="needs-validation" novalidate>
          <div class="mb-3"><label class="form-label" for="name">Full name</label><input class="form-control" id="name" name="name" minlength="3" maxlength="100" required><div class="invalid-feedback">Enter your name.</div></div>
          <div class="mb-3"><label class="form-label" for="phone">Phone number</label><input class="form-control" id="phone" name="phone" type="tel" pattern="[6-9][0-9]{9}" maxlength="10" required><div class="invalid-feedback">Enter a valid 10-digit number.</div></div>
          <div class="mb-3"><label class="form-label" for="interest">I am interested in</label>
            <select class="form-select" id="interest" name="interest">
              <option ${param.interest eq 'Free trial' ? 'selected' : ''}>Free trial</option><option>3-day pass</option><option>Student plan</option><option>Buddy plan</option><option>Something else</option></select></div>
          <div class="mb-3"><label class="form-label" for="message">Message (optional)</label><textarea class="form-control" id="message" name="message" rows="3" maxlength="500"></textarea></div>
          <button class="btn btn-orange w-100" type="submit">Send enquiry</button>
        </form></div></div>
    </div>
  </div>
</section>
<section class="section section-alt">
  <div class="container">
    <h2>FAQ</h2>
    <div class="accordion mt-3" id="faq">
      <div class="accordion-item"><h3 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f1">Can I cancel any time?</button></h3><div id="f1" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Monthly plans have no lock-in. Longer plans run for their full term.</div></div></div>
      <div class="accordion-item"><h3 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f2">Can I pause my membership?</button></h3><div id="f2" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Yes. Ask at the front desk to freeze it for a few weeks, for example during exams or holidays.</div></div></div>
      <div class="accordion-item"><h3 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f3">I am a beginner. Is that okay?</button></h3><div id="f3" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Absolutely. Our trainers will show you the basics on your first visit.</div></div></div>
      <div class="accordion-item"><h3 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f4">What should I bring?</button></h3><div id="f4" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Comfortable clothes, training shoes, a towel and a water bottle. Carry your college ID for the student plan.</div></div></div>
    </div>
  </div>
</section>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('form.needs-validation').forEach(function (f) {
      f.addEventListener('submit', function (e) { if (!f.checkValidity()) { e.preventDefault(); e.stopPropagation(); } f.classList.add('was-validated'); });
    });
  });
</script>
<%@ include file="inc/siteFooter.jsp" %>
