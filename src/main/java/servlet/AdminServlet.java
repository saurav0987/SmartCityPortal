package servlet;

import dao.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminServlet – aggregates statistics for the admin dashboard
 * and manages navigation to admin sub-modules.
 */
public class AdminServlet extends HttpServlet {

    private final UserDAO         userDAO         = new UserDAO();
    private final ComplaintDAO    complaintDAO    = new ComplaintDAO();
    private final AppointmentDAO  appointmentDAO  = new AppointmentDAO();
    private final BillDAO         billDAO         = new BillDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Only admin can access this servlet
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "dashboard";

        if ("dashboard".equals(action)) {
            req.setAttribute("totalUsers",         userDAO.getTotalUsers());
            req.setAttribute("totalComplaints",    complaintDAO.getTotalComplaints());
            req.setAttribute("pendingComplaints",  complaintDAO.getPendingCount());
            req.setAttribute("totalAppointments",  appointmentDAO.getTotalAppointments());
            req.setAttribute("unpaidBills",        billDAO.getUnpaidBillCount());
            req.setAttribute("totalAnnouncements", announcementDAO.getTotalAnnouncements());
            req.setAttribute("recentComplaints",   complaintDAO.getAllComplaints());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);

        } else if ("users".equals(action)) {
            req.setAttribute("users", userDAO.getAllCitizens());
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        }
    }
}
