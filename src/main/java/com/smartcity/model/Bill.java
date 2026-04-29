package com.smartcity.model;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "bills")
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bill_id")
    private int billId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE)
    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Column(length = 20)
    private String status = "Unpaid";

    @Column(name = "issued_at", updatable = false)
    private LocalDateTime issuedAt = LocalDateTime.now();

    @Transient
    private String userName;

    public Bill() {}

    // Getters and Setters
    public int getBillId()                    { return billId; }
    public void setBillId(int billId)         { this.billId = billId; }

    public User getUser()                     { return user; }
    public void setUser(User user)            { this.user = user; }

    public String getType()                   { return type; }
    public void setType(String type)          { this.type = type; }

    public BigDecimal getAmount()             { return amount; }
    public void setAmount(BigDecimal amount)  { this.amount = amount; }

    public LocalDate getDueDate()             { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public String getStatus()                 { return status; }
    public void setStatus(String status)      { this.status = status; }

    public LocalDateTime getIssuedAt()        { return issuedAt; }
    public void setIssuedAt(LocalDateTime t)  { this.issuedAt = t; }

    public String getUserName() {
        if (userName != null) return userName;
        if (user != null) return user.getName();
        return null;
    }
    public void setUserName(String userName)  { this.userName = userName; }
}
