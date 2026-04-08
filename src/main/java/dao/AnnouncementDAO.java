package dao;

import model.Announcement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    /** Post a new announcement (admin). */
    public boolean addAnnouncement(Announcement a) {
        String sql = "INSERT INTO announcements (title, content, category, posted_by) VALUES (?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, a.getTitle());
            ps.setString(2, a.getContent());
            ps.setString(3, a.getCategory());
            ps.setInt(4, a.getPostedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Get all announcements (newest first). */
    public List<Announcement> getAllAnnouncements() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, u.name AS posted_by_name FROM announcements a " +
                     "LEFT JOIN users u ON a.posted_by = u.id ORDER BY a.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Announcement a = extract(rs);
                a.setPostedByName(rs.getString("posted_by_name"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Delete an announcement by ID. */
    public boolean deleteAnnouncement(int id) {
        String sql = "DELETE FROM announcements WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Count total announcements. */
    public int getTotalAnnouncements() {
        String sql = "SELECT COUNT(*) FROM announcements";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Announcement extract(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setId(rs.getInt("id"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setCategory(rs.getString("category"));
        a.setPostedBy(rs.getInt("posted_by"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
