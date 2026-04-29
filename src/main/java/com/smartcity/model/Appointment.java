package com.smartcity.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "appointment_id")
    private int appointmentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "doctor_name", nullable = false)
    private String doctorName;

    private String specialization;

    @Column(nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private LocalTime time;

    @Column(length = 20)
    private String status = "Pending";

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Transient
    private String userName;

    public Appointment() {}

    // Getters and Setters
    public int getAppointmentId()                        { return appointmentId; }
    public void setAppointmentId(int appointmentId)      { this.appointmentId = appointmentId; }

    public User getUser()                                { return user; }
    public void setUser(User user)                        { this.user = user; }

    public String getDoctorName()                        { return doctorName; }
    public void setDoctorName(String doctorName)         { this.doctorName = doctorName; }

    public String getSpecialization()                    { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public LocalDate getDate()                           { return date; }
    public void setDate(LocalDate date)                  { this.date = date; }

    public LocalTime getTime()                           { return time; }
    public void setTime(LocalTime time)                  { this.time = time; }

    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }

    public String getNotes()                             { return notes; }
    public void setNotes(String notes)                   { this.notes = notes; }

    public LocalDateTime getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)    { this.createdAt = createdAt; }

    public String getUserName() {
        if (userName != null) return userName;
        if (user != null) return user.getName();
        return null;
    }
    public void setUserName(String userName) { this.userName = userName; }
}
