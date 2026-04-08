package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Bill {
    private int billId;
    private int userId;
    private String type;
    private BigDecimal amount;
    private Date dueDate;
    private String status;
    private Timestamp issuedAt;
    // For display
    private String userName;

    public Bill() {}

    // Getters and Setters
    public int getBillId()                    { return billId; }
    public void setBillId(int billId)         { this.billId = billId; }

    public int getUserId()                    { return userId; }
    public void setUserId(int userId)         { this.userId = userId; }

    public String getType()                   { return type; }
    public void setType(String type)          { this.type = type; }

    public BigDecimal getAmount()             { return amount; }
    public void setAmount(BigDecimal amount)  { this.amount = amount; }

    public Date getDueDate()                  { return dueDate; }
    public void setDueDate(Date dueDate)      { this.dueDate = dueDate; }

    public String getStatus()                 { return status; }
    public void setStatus(String status)      { this.status = status; }

    public Timestamp getIssuedAt()            { return issuedAt; }
    public void setIssuedAt(Timestamp t)      { this.issuedAt = t; }

    public String getUserName()               { return userName; }
    public void setUserName(String userName)  { this.userName = userName; }
}
