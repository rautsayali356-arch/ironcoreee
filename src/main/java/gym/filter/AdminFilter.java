package gym.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/** Only a logged-in administrator may open the admin servlets. */
@WebFilter({"/dashboard", "/members", "/member", "/plans", "/plan", "/payments", "/payment", "/profile"})
public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest r = (HttpServletRequest) req;
        HttpSession s = r.getSession(false);
        if (s == null || s.getAttribute("admin") == null) {
            ((HttpServletResponse) res).sendRedirect(r.getContextPath() + "/login.jsp");
            return;
        }
        chain.doFilter(req, res);
    }
}
