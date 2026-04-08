package servlet;

import dao.ComplaintDAO;
import model.Complaint;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        if ("list".equals(action)) {
            List<Complaint> complaints;
            if ("ADMIN".equals(role)) {
                complaints = complaintDAO.getAllComplaints();
                req.setAttribute("complaints", complaints);
                req.getRequestDispatcher("/admin/complaints.jsp").forward(req, resp);
            } else {
                complaints = complaintDAO.getComplaintsByUser(userId);
                req.setAttribute("complaints", complaints);
                req.getRequestDispatcher("/citizen/complaints.jsp").forward(req, resp);
            }
        } else if ("new".equals(action)) {
            req.getRequestDispatcher("/citizen/new-complaint.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String role   = (String) session.getAttribute("userRole");

        if ("add".equals(action)) {
            int userId = (int) session.getAttribute("userId");
            Complaint c = new Complaint();
            c.setUserId(userId);
            c.setCategory(req.getParameter("category"));
            c.setDescription(req.getParameter("description"));
            c.setLocation(req.getParameter("location"));

            boolean ok = complaintDAO.addComplaint(c);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/complaint?action=list&success=true");
            } else {
                req.setAttribute("error", "Failed to submit complaint. Try again.");
                req.getRequestDispatcher("/citizen/new-complaint.jsp").forward(req, resp);
            }

        } else if ("updateStatus".equals(action) && "ADMIN".equals(role)) {
            int complaintId  = Integer.parseInt(req.getParameter("complaintId"));
            String status    = req.getParameter("status");
            complaintDAO.updateStatus(complaintId, status);
            resp.sendRedirect(req.getContextPath() + "/complaint?action=list");
        }
    }
}
