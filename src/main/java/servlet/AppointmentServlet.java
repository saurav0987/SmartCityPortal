package servlet;

import dao.AppointmentDAO;
import model.Appointment;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public class AppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

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
            List<Appointment> appointments;
            if ("ADMIN".equals(role)) {
                appointments = appointmentDAO.getAllAppointments();
                req.setAttribute("appointments", appointments);
                req.getRequestDispatcher("/admin/appointments.jsp").forward(req, resp);
            } else {
                appointments = appointmentDAO.getAppointmentsByUser(userId);
                req.setAttribute("appointments", appointments);
                req.getRequestDispatcher("/citizen/appointments.jsp").forward(req, resp);
            }
        } else if ("new".equals(action)) {
            req.getRequestDispatcher("/citizen/book-appointment.jsp").forward(req, resp);
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

        if ("book".equals(action)) {
            int userId = (int) session.getAttribute("userId");
            Appointment a = new Appointment();
            a.setUserId(userId);
            a.setDoctorName(req.getParameter("doctorName"));
            a.setSpecialization(req.getParameter("specialization"));
            a.setDate(Date.valueOf(req.getParameter("date")));
            a.setTime(Time.valueOf(req.getParameter("time") + ":00"));
            a.setNotes(req.getParameter("notes"));

            boolean ok = appointmentDAO.addAppointment(a);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/appointment?action=list&success=true");
            } else {
                req.setAttribute("error", "Booking failed. Please try again.");
                req.getRequestDispatcher("/citizen/book-appointment.jsp").forward(req, resp);
            }

        } else if ("updateStatus".equals(action) && "ADMIN".equals(role)) {
            int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
            String status     = req.getParameter("status");
            appointmentDAO.updateStatus(appointmentId, status);
            resp.sendRedirect(req.getContextPath() + "/appointment?action=list");
        }
    }
}
