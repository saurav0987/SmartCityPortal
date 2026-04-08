package servlet;

import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name    = req.getParameter("name").trim();
        String email   = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();
        String phone   = req.getParameter("phone").trim();
        String address = req.getParameter("address").trim();

        // Basic validation
        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Name, email and password are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email)) {
            req.setAttribute("error", "This email is already registered. Please login.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);

        boolean success = userDAO.registerUser(user);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
