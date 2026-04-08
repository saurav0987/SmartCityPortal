package servlet;

import dao.AnnouncementDAO;
import model.Announcement;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AnnouncementServlet extends HttpServlet {

    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String role   = (String) session.getAttribute("userRole");

        List<Announcement> list = announcementDAO.getAllAnnouncements();
        req.setAttribute("announcements", list);

        if ("ADMIN".equals(role)) {
            req.getRequestDispatcher("/admin/announcements.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/citizen/announcements.jsp").forward(req, resp);
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

        if ("add".equals(action) && "ADMIN".equals(role)) {
            int adminId = (int) session.getAttribute("userId");
            Announcement a = new Announcement();
            a.setTitle(req.getParameter("title"));
            a.setContent(req.getParameter("content"));
            a.setCategory(req.getParameter("category"));
            a.setPostedBy(adminId);
            announcementDAO.addAnnouncement(a);
            resp.sendRedirect(req.getContextPath() + "/announcement?success=true");

        } else if ("delete".equals(action) && "ADMIN".equals(role)) {
            int id = Integer.parseInt(req.getParameter("id"));
            announcementDAO.deleteAnnouncement(id);
            resp.sendRedirect(req.getContextPath() + "/announcement");
        }
    }
}
