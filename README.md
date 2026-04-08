# 🏙️ Smart City Service Portal

A full-stack web application built with **Java Servlet + JSP**, **MySQL**, and **JDBC** for a B.Tech Java PBL project.

---

## 📁 Project Structure

```
SmartCityPortal/
├── pom.xml                          ← Maven build file
├── sql/
│   └── smartcity.sql                ← Database schema + sample data
└── src/main/
    ├── java/
    │   ├── model/                   ← POJO classes
    │   │   ├── User.java
    │   │   ├── Complaint.java
    │   │   ├── Appointment.java
    │   │   ├── Bill.java
    │   │   └── Announcement.java
    │   ├── dao/                     ← Database access layer
    │   │   ├── DBConnection.java
    │   │   ├── UserDAO.java
    │   │   ├── ComplaintDAO.java
    │   │   ├── AppointmentDAO.java
    │   │   ├── BillDAO.java
    │   │   └── AnnouncementDAO.java
    │   └── servlet/                 ← Controller layer
    │       ├── RegisterServlet.java
    │       ├── LoginServlet.java
    │       ├── LogoutServlet.java
    │       ├── ComplaintServlet.java
    │       ├── AppointmentServlet.java
    │       ├── BillServlet.java
    │       ├── AnnouncementServlet.java
    │       └── AdminServlet.java
    └── webapp/
        ├── index.jsp                ← Landing page
        ├── login.jsp
        ├── register.jsp
        ├── error.jsp
        ├── css/style.css
        ├── citizen/                 ← Citizen module JSPs
        │   ├── dashboard.jsp
        │   ├── profile.jsp
        │   ├── complaints.jsp
        │   ├── new-complaint.jsp
        │   ├── appointments.jsp
        │   ├── book-appointment.jsp
        │   ├── bills.jsp
        │   └── announcements.jsp
        ├── admin/                   ← Admin module JSPs
        │   ├── dashboard.jsp
        │   ├── users.jsp
        │   ├── complaints.jsp
        │   ├── appointments.jsp
        │   ├── bills.jsp
        │   └── announcements.jsp
        └── WEB-INF/
            └── web.xml
```

---

## ⚙️ Prerequisites

| Tool               | Version     |
|--------------------|-------------|
| Java JDK           | 11+         |
| Apache Tomcat      | 9 or 10     |
| MySQL Server       | 8.0+        |
| Maven              | 3.6+        |
| IDE                | Eclipse / IntelliJ IDEA |

---

## 🚀 Setup Instructions

### Step 1 – Setup the Database

1. Open **MySQL Workbench** or the MySQL CLI
2. Run the SQL file:
   ```sql
   source path/to/SmartCityPortal/sql/smartcity.sql;
   ```
   This creates the `smartcity_db` database with all 5 tables and sample data.

### Step 2 – Configure JDBC Connection

Open `src/main/java/dao/DBConnection.java` and update:
```java
private static final String DB_PASS = "root";   // ← your MySQL password
```
Also verify the user if different from `root`.

### Step 3 – Build the Project (Maven)

```bash
cd SmartCityPortal
mvn clean package
```
This generates `target/SmartCityPortal.war`.

### Step 4 – Deploy to Tomcat

1. Copy `target/SmartCityPortal.war` to `TOMCAT_HOME/webapps/`
2. Start Tomcat:
   ```
   TOMCAT_HOME/bin/startup.bat
   ```
3. Open in browser:
   ```
   http://localhost:8080/SmartCityPortal/
   ```

---

## 🔑 Default Login Credentials

| Role    | Email                  | Password   |
|---------|------------------------|------------|
| Admin   | admin@smartcity.com    | admin123   |
| Citizen | ravi@email.com         | pass123    |
| Citizen | priya@email.com        | pass123    |
| Citizen | amit@email.com         | pass123    |

---

## 🌟 Features

### Citizen Module
- 📋 Register & track complaints (Road, Water, Electricity, Garbage)
- 🏥 Book hospital appointments
- 💡 View & pay utility bills (Electricity, Water, Property Tax, Sewage)
- 📢 Read city announcements
- 👤 View personal profile

### Admin Module
- 📊 Dashboard with live statistics
- 👥 View all registered citizens
- 📋 Manage complaints (update: Pending → In Progress → Resolved)
- 🏥 Manage appointments (Confirm / Cancel)
- 💡 Issue new bills to citizens
- 📢 Post / delete city announcements

---

## 🏗️ MVC Architecture

```
Browser Request
     ↓
  Servlet (Controller)
     ↓
  DAO (Model/DB Layer) ←→ MySQL Database
     ↓
  JSP (View)
     ↓
Browser Response
```

---

## 📦 Maven Dependencies Used

| Dependency                  | Purpose                    |
|-----------------------------|----------------------------|
| javax.servlet-api           | Servlet API                |
| javax.servlet.jsp-api       | JSP API                    |
| javax.servlet:jstl          | JSP Standard Tag Library   |
| mysql-connector-java        | JDBC Driver for MySQL      |

---

## 🎓 Academic Details

- **Project Type**: B.Tech 2nd Year Java PBL
- **Architecture**: MVC (Model-View-Controller)
- **Database**: MySQL + JDBC (PreparedStatement)
- **Session Management**: HttpSession
- **Security**: Role-based access control (ADMIN / CITIZEN)
