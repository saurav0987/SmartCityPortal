package servlet;

import dao.BillDAO;
import model.Bill;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

public class BillServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();

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
            List<Bill> bills;
            if ("ADMIN".equals(role)) {
                bills = billDAO.getAllBills();
                req.setAttribute("bills", bills);
                req.getRequestDispatcher("/admin/bills.jsp").forward(req, resp);
            } else {
                bills = billDAO.getBillsByUser(userId);
                req.setAttribute("bills", bills);
                req.getRequestDispatcher("/citizen/bills.jsp").forward(req, resp);
            }
        } else if ("new".equals(action) && "ADMIN".equals(role)) {
            req.getRequestDispatcher("/admin/bills.jsp").forward(req, resp);
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
            Bill b = new Bill();
            b.setUserId(Integer.parseInt(req.getParameter("userId")));
            b.setType(req.getParameter("type"));
            b.setAmount(new BigDecimal(req.getParameter("amount")));
            b.setDueDate(Date.valueOf(req.getParameter("dueDate")));
            billDAO.addBill(b);
            resp.sendRedirect(req.getContextPath() + "/bill?action=list&success=true");

        } else if ("pay".equals(action)) {
            int billId = Integer.parseInt(req.getParameter("billId"));
            billDAO.markAsPaid(billId);
            resp.sendRedirect(req.getContextPath() + "/bill?action=list&paid=true");
        }
    }
}
