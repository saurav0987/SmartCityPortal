package model;

import java.sql.Timestamp;

public class Complaint {
    private int complaintId;
    private int userId;
    private String category;
    private String description;
    private String location;
    private String status;
    private Timestamp date;
    // For display purposes
    private String userName;

    public Complaint() {}

    public Complaint(int complaintId, int userId, String category,
                     String description, String location, String status, Timestamp date) {
        this.complaintId = complaintId;
        this.userId = userId;
        this.category = category;
        this.description = description;
        this.location = location;
        this.status = status;
        this.date = date;
    }

    // Getters and Setters
    public int getComplaintId()                    { return complaintId; }
    public void setComplaintId(int complaintId)    { this.complaintId = complaintId; }

    public int getUserId()                         { return userId; }
    public void setUserId(int userId)              { this.userId = userId; }

    public String getCategory()                    { return category; }
    public void setCategory(String category)       { this.category = category; }

    public String getDescription()                 { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation()                    { return location; }
    public void setLocation(String location)       { this.location = location; }

    public String getStatus()                      { return status; }
    public void setStatus(String status)           { this.status = status; }

    public Timestamp getDate()                     { return date; }
    public void setDate(Timestamp date)            { this.date = date; }

    public String getUserName()                    { return userName; }
    public void setUserName(String userName)       { this.userName = userName; }
}
