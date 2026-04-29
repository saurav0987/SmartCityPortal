package com.smartcity.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "complaints")
public class Complaint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "complaint_id")
    private int complaintId;

    @com.fasterxml.jackson.annotation.JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String category;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String location;

    @Column(length = 20)
    private String status = "Pending";

    @Column(name = "date")
    private LocalDateTime date = LocalDateTime.now();

    private double latitude;
    private double longitude;

    @Column(name = "image_path")
    private String imagePath;

    @Transient
    private String userName; // For legacy display logic

    public Complaint() {}

    // Getters and Setters
    public int getComplaintId()                    { return complaintId; }
    public void setComplaintId(int complaintId)    { this.complaintId = complaintId; }

    public User getUser()                          { return user; }
    public void setUser(User user)                 { this.user = user; }

    public String getCategory()                    { return category; }
    public void setCategory(String category)       { this.category = category; }

    public String getDescription()                 { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation()                    { return location; }
    public void setLocation(String location)       { this.location = location; }

    public String getStatus()                      { return status; }
    public void setStatus(String status)           { this.status = status; }

    public LocalDateTime getDate()                 { return date; }
    public void setDate(LocalDateTime date)        { this.date = date; }

    public double getLatitude()                    { return latitude; }
    public void setLatitude(double latitude)       { this.latitude = latitude; }

    public double getLongitude()                   { return longitude; }
    public void setLongitude(double longitude)     { this.longitude = longitude; }

    public String getImagePath()                   { return imagePath; }
    public void setImagePath(String imagePath)     { this.imagePath = imagePath; }

    public String getUserName() {
        if (userName != null) return userName;
        if (user != null) return user.getName();
        return null;
    }
    public void setUserName(String userName) { this.userName = userName; }
}
