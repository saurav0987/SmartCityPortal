package model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Appointment {
    private int appointmentId;
    private int userId;
    private String doctorName;
    private String specialization;
    private Date date;
    private Time time;
    private String status;
    private String notes;
    private Timestamp createdAt;
    // For display
    private String userName;

    public Appointment() {}

    // Getters and Setters
    public int getAppointmentId()                        { return appointmentId; }
    public void setAppointmentId(int appointmentId)      { this.appointmentId = appointmentId; }

    public int getUserId()                               { return userId; }
    public void setUserId(int userId)                    { this.userId = userId; }

    public String getDoctorName()                        { return doctorName; }
    public void setDoctorName(String doctorName)         { this.doctorName = doctorName; }

    public String getSpecialization()                        { return specialization; }
    public void setSpecialization(String specialization)     { this.specialization = specialization; }

    public Date getDate()                                { return date; }
    public void setDate(Date date)                       { this.date = date; }

    public Time getTime()                                { return time; }
    public void setTime(Time time)                       { this.time = time; }

    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }

    public String getNotes()                             { return notes; }
    public void setNotes(String notes)                   { this.notes = notes; }

    public Timestamp getCreatedAt()                      { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)        { this.createdAt = createdAt; }

    public String getUserName()                          { return userName; }
    public void setUserName(String userName)             { this.userName = userName; }
}
