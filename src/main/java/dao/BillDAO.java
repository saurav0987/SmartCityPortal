package dao;

import model.Bill;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    /** Add a new bill (admin). */
    public boolean addBill(Bill b) {
        String sql = "INSERT INTO bills (user_id, type, amount, due_date, status) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setString(2, b.getType());
            ps.setBigDecimal(3, b.getAmount());
            ps.setDate(4, b.getDueDate());
            ps.setString(5, "Unpaid");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Get bills for a specific citizen. */
    public List<Bill> getBillsByUser(int userId) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM bills WHERE user_id = ? ORDER BY due_date ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Get all bills (admin view). */
    public List<Bill> getAllBills() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT b.*, u.name AS user_name FROM bills b " +
                     "JOIN users u ON b.user_id = u.id ORDER BY b.due_date ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill b = extract(rs);
                b.setUserName(rs.getString("user_name"));
                list.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Mark a bill as Paid. */
    public boolean markAsPaid(int billId) {
        String sql = "UPDATE bills SET status = 'Paid' WHERE bill_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, billId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Count unpaid bills. */
    public int getUnpaidBillCount() {
        String sql = "SELECT COUNT(*) FROM bills WHERE status='Unpaid'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Bill extract(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setBillId(rs.getInt("bill_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setType(rs.getString("type"));
        b.setAmount(rs.getBigDecimal("amount"));
        b.setDueDate(rs.getDate("due_date"));
        b.setStatus(rs.getString("status"));
        b.setIssuedAt(rs.getTimestamp("issued_at"));
        return b;
    }
}
