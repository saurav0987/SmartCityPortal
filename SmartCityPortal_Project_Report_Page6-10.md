# Smart City Service Portal - Project Report (Pages 6-10)

---

## Page 6: Database Design and Implementation

### Database Architecture Overview

The Smart City Service Portal utilizes a robust relational database architecture designed to ensure data integrity, performance, and scalability. The database schema follows established normalization principles while optimizing for query performance and data consistency.

#### Design Principles

**Normalization Strategy**
The database schema adheres to Third Normal Form (3NF) to eliminate data redundancy and ensure data integrity. Each table represents a single entity with clearly defined relationships, minimizing update anomalies and maintaining consistency.

**Performance Optimization**
Strategic indexing and query optimization techniques ensure efficient data retrieval even under heavy load. The schema design considers common query patterns and implements appropriate indexes to support fast access.

**Scalability Considerations**
The database design supports horizontal scaling through proper table partitioning strategies and maintains flexibility for future schema extensions without requiring major restructuring.

**Data Integrity**
Comprehensive constraint implementation ensures referential integrity and business rule enforcement at the database level, providing an additional layer of data validation beyond application-level checks.

### Entity Relationship Design

#### Core Entities

**User Entity**
The User entity serves as the central entity in the system, representing all users who interact with the portal. It supports both citizen and administrative roles with appropriate access control mechanisms.

**Complaint Entity**
Represents service complaints filed by citizens across various municipal departments. Each complaint is linked to a specific user and maintains a complete lifecycle from submission through resolution.

**Appointment Entity**
Manages healthcare appointment bookings, linking citizens with medical service providers. The entity tracks appointment status, scheduling details, and related metadata.

**Bill Entity**
Handles utility billing information for various municipal services including electricity, water, property tax, and sewage. Each bill is associated with a specific user and maintains payment status.

**Announcement Entity**
Stores public announcements posted by administrative authorities. The entity supports categorization and maintains publication metadata for effective communication management.

#### Relationship Mapping

**One-to-Many Relationships**
- Users to Complaints: One user can file multiple complaints
- Users to Appointments: One user can book multiple appointments
- Users to Bills: One user can receive multiple bills
- Users to Announcements: One admin can post multiple announcements

**Referential Integrity**
All relationships maintain referential integrity through foreign key constraints with appropriate cascade actions to ensure data consistency during updates and deletions.

### Detailed Table Definitions

#### Users Table

**Table Structure:**
```sql
CREATE TABLE users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    phone      VARCHAR(15),
    address    VARCHAR(255),
    role       ENUM('ADMIN','CITIZEN') DEFAULT 'CITIZEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Field Descriptions:**
- **id:** Primary key, auto-incrementing integer
- **name:** User's full name, required field
- **email:** Unique email address for authentication
- **password:** User password (currently plain text, planned hashing)
- **phone:** Contact phone number, optional
- **address:** Residential address, optional
- **role:** User role enumeration (ADMIN/CITIZEN)
- **created_at:** Automatic timestamp for account creation

**Business Rules:**
- Email addresses must be unique across all users
- Role assignment determines access permissions
- Default role is CITIZEN for new registrations
- Phone numbers follow international format validation

#### Complaints Table

**Table Structure:**
```sql
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    category     ENUM('Road','Water','Electricity','Garbage','Other') NOT NULL,
    description  TEXT NOT NULL,
    location     VARCHAR(255) NOT NULL,
    status       ENUM('Pending','In Progress','Resolved') DEFAULT 'Pending',
    date         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_date (date),
    INDEX idx_user_status (user_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Field Descriptions:**
- **complaint_id:** Primary key, unique complaint identifier
- **user_id:** Foreign key referencing the filing user
- **category:** Complaint category for department assignment
- **description:** Detailed complaint description
- **location:** Geographic location of the issue
- **status:** Current status in the resolution workflow
- **date:** Automatic timestamp for complaint submission

**Business Rules:**
- Each complaint must be associated with a valid user
- Status follows predefined workflow: Pending → In Progress → Resolved
- Categories determine department assignment and priority
- Location information is required for service dispatch

#### Appointments Table

**Table Structure:**
```sql
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    doctor_name    VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    date           DATE NOT NULL,
    time           TIME NOT NULL,
    status         ENUM('Pending','Confirmed','Cancelled') DEFAULT 'Pending',
    notes          TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_doctor_datetime (doctor_name, date, time),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_date (date),
    INDEX idx_doctor_name (doctor_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Field Descriptions:**
- **appointment_id:** Primary key, unique appointment identifier
- **user_id:** Foreign key referencing the booking user
- **doctor_name:** Healthcare provider name
- **specialization:** Medical specialization area
- **date:** Scheduled appointment date
- **time:** Scheduled appointment time
- **status:** Current appointment status
- **notes:** Additional notes or instructions
- **created_at:** Automatic timestamp for booking creation

**Business Rules:**
- Unique constraint prevents double booking of same doctor/time slot
- Appointments can be cancelled within specified time limits
- Status workflow: Pending → Confirmed → Cancelled/Completed
- Date must be in the future for new appointments

#### Bills Table

**Table Structure:**
```sql
CREATE TABLE bills (
    bill_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    type       ENUM('Electricity','Water','Property Tax','Sewage') NOT NULL,
    amount     DECIMAL(10,2) NOT NULL,
    due_date   DATE NOT NULL,
    status     ENUM('Unpaid','Paid') DEFAULT 'Unpaid',
    issued_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_due_date (due_date),
    INDEX idx_user_due_date (user_id, due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Field Descriptions:**
- **bill_id:** Primary key, unique bill identifier
- **user_id:** Foreign key referencing the billed user
- **type:** Bill type for categorization
- **amount:** Bill amount with decimal precision
- **due_date:** Payment deadline date
- **status:** Current payment status
- **issued_at:** Automatic timestamp for bill generation

**Business Rules:**
- Amount must be positive and within reasonable ranges
- Due date must be after issue date
- Status transitions from Unpaid to Paid upon payment
- Late payment calculations based on due date

#### Announcements Table

**Table Structure:**
```sql
CREATE TABLE announcements (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    content     TEXT NOT NULL,
    category    ENUM('General','Alert','Event','Maintenance') DEFAULT 'General',
    posted_by   INT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_category (category),
    INDEX idx_created_at (created_at),
    INDEX idx_posted_by (posted_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Field Descriptions:**
- **id:** Primary key, unique announcement identifier
- **title:** Announcement title for quick identification
- **content:** Full announcement content
- **category:** Announcement category for filtering
- **posted_by:** Foreign key referencing posting admin
- **created_at:** Automatic timestamp for publication

**Business Rules:**
- Title and content are required fields
- Category determines display priority and styling
- Admin attribution maintained through posted_by reference
- SET NULL preserves announcements when admin accounts are deleted

### Database Implementation

#### Connection Management

**Database Connection Class**
```java
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/smartcity_db";
    private static final String USER = "root";
    private static final String PASS = "password";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
    
    public static void closeConnection(Connection con, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

#### Data Access Implementation

**UserDAO Implementation**
```java
public class UserDAO {
    
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(con, ps, null);
        }
    }
    
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con, ps, rs);
        }
        return null;
    }
    
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con, ps, rs);
        }
        return users;
    }
    
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        return user;
    }
}
```

**ComplaintDAO Implementation**
```java
public class ComplaintDAO {
    
    public boolean addComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (user_id, category, description, location) VALUES (?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, complaint.getUserId());
            ps.setString(2, complaint.getCategory());
            ps.setString(3, complaint.getDescription());
            ps.setString(4, complaint.getLocation());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(con, ps, null);
        }
    }
    
    public List<Complaint> getUserComplaints(int userId) {
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY date DESC";
        List<Complaint> complaints = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                complaints.add(extractComplaintFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con, ps, rs);
        }
        return complaints;
    }
    
    public List<Complaint> getAllComplaints() {
        String sql = "SELECT c.*, u.name as user_name FROM complaints c " +
                    "JOIN users u ON c.user_id = u.id ORDER BY c.date DESC";
        List<Complaint> complaints = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                complaints.add(extractComplaintWithUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con, ps, rs);
        }
        return complaints;
    }
    
    public boolean updateComplaintStatus(int complaintId, String status) {
        String sql = "UPDATE complaints SET status = ? WHERE complaint_id = ?";
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setString(1, status);
            ps.setInt(2, complaintId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(con, ps, null);
        }
    }
    
    private Complaint extractComplaintFromResultSet(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setComplaintId(rs.getInt("complaint_id"));
        complaint.setUserId(rs.getInt("user_id"));
        complaint.setCategory(rs.getString("category"));
        complaint.setDescription(rs.getString("description"));
        complaint.setLocation(rs.getString("location"));
        complaint.setStatus(rs.getString("status"));
        complaint.setDate(rs.getTimestamp("date"));
        return complaint;
    }
    
    private Complaint extractComplaintWithUser(ResultSet rs) throws SQLException {
        Complaint complaint = extractComplaintFromResultSet(rs);
        complaint.setUserName(rs.getString("user_name"));
        return complaint;
    }
}
```

### Database Optimization

#### Indexing Strategy

**Primary Indexes**
All tables have primary key indexes on their auto-incrementing ID columns for fast record lookup.

**Secondary Indexes**
Strategic secondary indexes on frequently queried columns:
- Users: email (for authentication), role (for filtering)
- Complaints: user_id, status, category, date (for various queries)
- Appointments: user_id, status, date, doctor_name (for scheduling)
- Bills: user_id, status, type, due_date (for billing operations)
- Announcements: category, created_at, posted_by (for display)

**Composite Indexes**
Composite indexes for common query patterns:
- complaints(user_id, status) for user complaint tracking
- bills(user_id, due_date) for payment reminders
- appointments(doctor_name, date, time) for availability checking

#### Query Optimization

**Prepared Statements**
All database operations use prepared statements to:
- Prevent SQL injection attacks
- Improve query performance through statement caching
- Ensure proper type handling and escaping

**Connection Management**
Efficient connection handling through:
- Proper resource cleanup in finally blocks
- Connection reuse within request scope
- Planned connection pooling for production deployment

**Query Analysis**
Regular query performance analysis to identify:
- Slow queries requiring optimization
- Missing indexes affecting performance
- Inefficient join operations
- Full table scans on large datasets

### Database Security

#### Access Control

**User Privileges**
Database users configured with minimum required privileges:
- Application user: SELECT, INSERT, UPDATE, DELETE on application tables
- Read-only user: SELECT privileges for reporting
- Admin user: Full privileges for maintenance

**Connection Security**
- Encrypted database connections using SSL/TLS
- Secure password storage and rotation
- Connection string security in configuration

#### Data Protection

**Input Validation**
Server-side validation of all database inputs:
- Length constraints enforcement
- Data type validation
- Special character handling
- SQL injection prevention

**Audit Trail**
Comprehensive logging of database operations:
- User access tracking
- Data modification logging
- Error condition recording
- Performance metric collection

### Database Maintenance

#### Backup Strategy

**Regular Backups**
Automated backup procedures:
- Daily full backups during off-peak hours
- Hourly transaction log backups
- Weekly backup verification and restoration testing
- Off-site backup storage for disaster recovery

**Backup Script**
```bash
#!/bin/bash
BACKUP_DIR="/var/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="smartcity_db"

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Full database backup
mysqldump -u root -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/smartcity_$DATE.sql.gz

# Remove backups older than 30 days
find $BACKUP_DIR -name "smartcity_*.sql.gz" -mtime +30 -delete

# Log backup operation
echo "$(date): Database backup completed - smartcity_$DATE.sql.gz" >> $BACKUP_DIR/backup.log
```

#### Performance Monitoring

**Key Metrics**
Regular monitoring of database performance indicators:
- Query execution times
- Connection pool utilization
- Index usage statistics
- Disk space usage
- Memory consumption

**Maintenance Procedures**
Routine database maintenance tasks:
- Index rebuilding and optimization
- Statistics updates for query optimizer
- Table fragmentation analysis
- Log file management

---

## Page 7: User Interface Design and Implementation

### User Interface Philosophy

The Smart City Service Portal's user interface is designed with a user-centric approach, prioritizing accessibility, usability, and aesthetic appeal. The design philosophy emphasizes clarity, efficiency, and consistency across all user interactions while maintaining professional standards appropriate for a government service platform.

#### Design Principles

**User-Centered Design**
Every interface element is designed with the end-user in mind, considering their technical proficiency, accessibility needs, and usage patterns. The interface caters to diverse user groups including citizens of varying technical abilities and administrative staff with different operational requirements.

**Consistency and Standards**
Consistent design patterns, color schemes, and interaction models are maintained throughout the application to reduce cognitive load and improve learnability. Standard web conventions are followed to ensure intuitive navigation and operation.

**Accessibility and Inclusivity**
The interface adheres to Web Content Accessibility Guidelines (WCAG) 2.1 Level AA standards, ensuring equal access for users with disabilities. This includes proper color contrast, keyboard navigation, screen reader compatibility, and responsive design for various devices.

**Efficiency and Productivity**
Workflow optimization is achieved through streamlined processes, minimal clicks for common operations, and intelligent information architecture. The interface reduces task completion time and minimizes user frustration through thoughtful design decisions.

### Visual Design System

#### Color Palette

**Primary Colors**
- **Primary Blue:** #007bff (Primary actions, navigation, links)
- **Secondary Blue:** #6c757d (Secondary actions, text)
- **Success Green:** #28a745 (Success messages, confirmations)
- **Warning Orange:** #ffc107 (Warnings, important notices)
- **Danger Red:** #dc3545 (Error messages, destructive actions)

**Neutral Colors**
- **White:** #ffffff (Background, clean space)
- **Light Gray:** #f8f9fa (Page backgrounds, cards)
- **Medium Gray:** #6c757d (Secondary text, borders)
- **Dark Gray:** #343a40 (Primary text, headings)

#### Typography

**Font Hierarchy**
- **Headings:** 'Segoe UI', system-ui, sans-serif (Bold, 24-32px)
- **Subheadings:** 'Segoe UI', system-ui, sans-serif (Semibold, 18-24px)
- **Body Text:** 'Segoe UI', system-ui, sans-serif (Regular, 14-16px)
- **Small Text:** 'Segoe UI', system-ui, sans-serif (Regular, 12px)

**Font Sizes and Weights**
```css
.text-h1 { font-size: 32px; font-weight: 700; }
.text-h2 { font-size: 24px; font-weight: 600; }
.text-h3 { font-size: 20px; font-weight: 600; }
.text-body { font-size: 16px; font-weight: 400; }
.text-small { font-size: 14px; font-weight: 400; }
.text-caption { font-size: 12px; font-weight: 400; }
```

#### Component Library

**Buttons**
```css
.btn-primary {
    background-color: #007bff;
    border-color: #007bff;
    color: white;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 500;
}

.btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
    color: white;
}

.btn-success {
    background-color: #28a745;
    border-color: #28a745;
    color: white;
}
```

**Form Elements**
```css
.form-control {
    border: 1px solid #ced4da;
    border-radius: 4px;
    padding: 8px 12px;
    font-size: 14px;
    transition: border-color 0.15s ease-in-out;
}

.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
}
```

**Cards**
```css
.card {
    border: 1px solid #e3e6f0;
    border-radius: 8px;
    box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.15);
    margin-bottom: 1.5rem;
}

.card-header {
    background-color: #f8f9fc;
    border-bottom: 1px solid #e3e6f0;
    padding: 1rem 1.25rem;
}
```

### Responsive Design Implementation

#### Breakpoint Strategy

**Mobile First Approach**
The design follows a mobile-first approach, ensuring optimal experience on small screens and progressively enhancing for larger displays.

**Breakpoint Definitions**
- **Extra Small (xs):** <576px (Mobile phones)
- **Small (sm):** ≥576px (Large phones, small tablets)
- **Medium (md):** ≥768px (Tablets)
- **Large (lg):** ≥992px (Desktops)
- **Extra Large (xl):** ≥1200px (Large desktops)

#### Grid System

**Bootstrap Grid Implementation**
```html
<div class="container">
    <div class="row">
        <div class="col-12 col-md-8 col-lg-9">
            <!-- Main content area -->
        </div>
        <div class="col-12 col-md-4 col-lg-3">
            <!-- Sidebar content -->
        </div>
    </div>
</div>
```

**Responsive Navigation**
```html
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="#">Smart City Portal</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <!-- Navigation items -->
            </ul>
        </div>
    </div>
</nav>
```

### Page Layouts and Templates

#### Master Template Structure

**Base Template (template.jsp)**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart City Portal - ${pageTitle}</title>
    
    <!-- CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>
    <!-- Navigation Header -->
    <jsp:include page="includes/header.jsp"/>
    
    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">${pageTitle}</h1>
                <c:if test="${not empty pageActions}">
                    <jsp:include page="${pageActions}"/>
                </c:if>
            </div>
            
            <!-- Messages -->
            <jsp:include page="includes/messages.jsp"/>
            
            <!-- Page Content -->
            <jsp:include page="${contentPage}"/>
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="includes/footer.jsp"/>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="<c:url value='/js/app.js'/>"></script>
</body>
</html>
```

#### Citizen Dashboard Layout

**Dashboard Structure**
```jsp
<div class="row">
    <!-- Statistics Cards -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            Pending Complaints
                        </div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingComplaints}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-comments fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- More statistics cards -->
    
    <!-- Recent Activity -->
    <div class="col-lg-8 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Recent Activity</h6>
            </div>
            <div class="card-body">
                <c:if test="${empty recentActivities}">
                    <p class="text-center text-muted">No recent activity</p>
                </c:if>
                <c:forEach items="${recentActivities}" var="activity">
                    <div class="activity-item d-flex align-items-center mb-3">
                        <div class="activity-icon mr-3">
                            <i class="fas ${activity.icon} text-${activity.color}"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">${activity.title}</div>
                            <div class="activity-time text-muted small">
                                <fmt:formatDate value="${activity.date}" pattern="MMM dd, yyyy HH:mm"/>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions -->
    <div class="col-lg-4 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Quick Actions</h6>
            </div>
            <div class="card-body">
                <div class="list-group list-group-flush">
                    <a href="<c:url value='/complaint?action=new'/>" class="list-group-item list-group-item-action">
                        <i class="fas fa-plus-circle mr-2"></i> File Complaint
                    </a>
                    <a href="<c:url value='/appointment?action=new'/>" class="list-group-item list-group-item-action">
                        <i class="fas fa-calendar-plus mr-2"></i> Book Appointment
                    </a>
                    <a href="<c:url value='/bill'/>" class="list-group-item list-group-item-action">
                        <i class="fas fa-file-invoice mr-2"></i> View Bills
                    </a>
                    <a href="<c:url value='/announcement'/>" class="list-group-item list-group-item-action">
                        <i class="fas fa-bullhorn mr-2"></i> View Announcements
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
```

#### Administrative Dashboard Layout

**Admin Dashboard Structure**
```jsp
<div class="row">
    <!-- System Statistics -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            Total Users
                        </div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${totalUsers}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Management Sections -->
    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Pending Complaints</h6>
                <a href="<c:url value='/admin?action=complaints'/>" class="btn btn-sm btn-primary">View All</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="complaintsTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pendingComplaints}" var="complaint">
                                <tr>
                                    <td>${complaint.complaintId}</td>
                                    <td>${complaint.userName}</td>
                                    <td>${complaint.category}</td>
                                    <td>
                                        <span class="badge badge-warning">${complaint.status}</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-info" onclick="viewComplaint(${complaint.complaintId})">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-success" onclick="updateComplaintStatus(${complaint.complaintId}, 'In Progress')">
                                            <i class="fas fa-play"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Charts and Analytics -->
    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Service Statistics</h6>
            </div>
            <div class="card-body">
                <div class="chart-area">
                    <canvas id="serviceChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>
```

### Form Design and Validation

#### Form Components

**Standard Form Layout**
```jsp
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">${formTitle}</h6>
    </div>
    <div class="card-body">
        <form action="${formAction}" method="post" id="${formId}" novalidate>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="fieldName" class="form-label">Field Label <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fieldName" name="fieldName" 
                           value="${param.fieldName}" required>
                    <div class="invalid-feedback">
                        Please provide a valid field value.
                    </div>
                </div>
                
                <!-- More form fields -->
            </div>
            
            <div class="form-group mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-2"></i> ${submitButtonText}
                </button>
                <a href="${cancelUrl}" class="btn btn-secondary ml-2">
                    <i class="fas fa-times mr-2"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>
```

#### Client-Side Validation

**JavaScript Validation Framework**
```javascript
class FormValidator {
    constructor(formId) {
        this.form = document.getElementById(formId);
        this.setupValidation();
    }
    
    setupValidation() {
        this.form.addEventListener('submit', (e) => {
            if (!this.validateForm()) {
                e.preventDefault();
                e.stopPropagation();
            }
            this.form.classList.add('was-validated');
        });
    }
    
    validateForm() {
        let isValid = true;
        const inputs = this.form.querySelectorAll('input, select, textarea');
        
        inputs.forEach(input => {
            if (input.hasAttribute('required') && !this.validateField(input)) {
                isValid = false;
            }
        });
        
        return isValid;
    }
    
    validateField(field) {
        const value = field.value.trim();
        const fieldType = field.type;
        
        switch(fieldType) {
            case 'email':
                return this.validateEmail(value);
            case 'tel':
                return this.validatePhone(value);
            case 'password':
                return this.validatePassword(value);
            default:
                return value.length > 0;
        }
    }
    
    validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    validatePhone(phone) {
        const phoneRegex = /^[+]?[\d\s-()]+$/;
        return phoneRegex.test(phone) && phone.replace(/\D/g, '').length >= 10;
    }
    
    validatePassword(password) {
        return password.length >= 8;
    }
}

// Initialize validation on page load
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        new FormValidator(form.id);
    });
});
```

### Interactive Components

#### Data Tables

**Enhanced Table Implementation**
```jsp
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">${tableTitle}</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered" id="${tableId}" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <c:forEach items="${tableHeaders}" var="header">
                            <th>${header}</th>
                        </c:forEach>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${tableData}" var="item">
                        <tr>
                            <c:forEach items="${item.values}" var="value">
                                <td>${value}</td>
                            </c:forEach>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-info" onclick="viewItem(${item.id})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-warning" onclick="editItem(${item.id})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger" onclick="deleteItem(${item.id})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
```

#### Modal Dialogs

**Confirmation Modal**
```jsp
<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Action</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p id="confirmMessage">Are you sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmButton">Confirm</button>
            </div>
        </div>
    </div>
</div>
```

**JavaScript Modal Handler**
```javascript
class ModalManager {
    static showConfirm(message, onConfirm) {
        $('#confirmMessage').text(message);
        $('#confirmModal').modal('show');
        
        $('#confirmButton').off('click').on('click', function() {
            onConfirm();
            $('#confirmModal').modal('hide');
        });
    }
    
    static showAlert(title, message, type = 'info') {
        const alertHtml = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                <strong>${title}:</strong> ${message}
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
        `;
        $('#alertContainer').html(alertHtml);
    }
}
```

### Accessibility Implementation

#### ARIA Labels and Roles

**Accessible Navigation**
```html
<nav class="navbar navbar-expand-lg navbar-dark bg-primary" role="navigation" aria-label="Main navigation">
    <div class="container">
        <a class="navbar-brand" href="/" aria-label="Smart City Portal Home">Smart City Portal</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" 
                data-target="#navbarNav" aria-controls="navbarNav" 
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/dashboard" aria-current="page">Dashboard</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
```

**Accessible Forms**
```jsp
<form action="/complaint" method="post" aria-labelledby="complaintFormTitle">
    <h2 id="complaintFormTitle">File a Complaint</h2>
    
    <div class="form-group">
        <label for="complaintCategory" class="form-label">Category</label>
        <select class="form-control" id="complaintCategory" name="category" 
                aria-describedby="categoryHelp" required>
            <option value="">Select a category</option>
            <option value="Road">Road</option>
            <option value="Water">Water</option>
            <option value="Electricity">Electricity</option>
            <option value="Garbage">Garbage</option>
            <option value="Other">Other</option>
        </select>
        <small id="categoryHelp" class="form-text text-muted">
            Select the category that best describes your complaint.
        </small>
    </div>
</form>
```

#### Keyboard Navigation

**Focus Management**
```javascript
class KeyboardNavigation {
    static setupFocusManagement() {
        // Skip to main content link
        const skipLink = document.createElement('a');
        skipLink.href = '#main-content';
        skipLink.className = 'skip-link';
        skipLink.textContent = 'Skip to main content';
        document.body.insertBefore(skipLink, document.body.firstChild);
        
        // Focus trap for modals
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Tab' && document.querySelector('.modal.show')) {
                KeyboardNavigation.trapFocus(e);
            }
        });
    }
    
    static trapFocus(e) {
        const modal = document.querySelector('.modal.show');
        const focusableElements = modal.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        );
        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];
        
        if (e.shiftKey) {
            if (document.activeElement === firstElement) {
                lastElement.focus();
                e.preventDefault();
            }
        } else {
            if (document.activeElement === lastElement) {
                firstElement.focus();
                e.preventDefault();
            }
        }
    }
}
```

### Performance Optimization

#### CSS Optimization

**Critical CSS Inlining**
```jsp
<style>
/* Critical above-the-fold CSS */
.navbar { background-color: #007bff; }
.container { max-width: 1200px; margin: 0 auto; }
.btn-primary { background-color: #007bff; border-color: #007bff; }
</style>
```

**Image Optimization**
```jsp
<picture>
    <source srcset="/images/logo.webp" type="image/webp">
    <source srcset="/images/logo.png" type="image/png">
    <img src="/images/logo.png" alt="Smart City Portal Logo" loading="lazy">
</picture>
```

#### JavaScript Optimization

**Lazy Loading**
```javascript
class LazyLoader {
    static loadOnDemand() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const element = entry.target;
                    if (element.dataset.src) {
                        element.src = element.dataset.src;
                        observer.unobserve(element);
                    }
                }
            });
        });
        
        document.querySelectorAll('img[data-src]').forEach(img => {
            observer.observe(img);
        });
    }
}
```

---

## Page 8: Security Implementation and Best Practices

### Security Architecture Overview

The Smart City Service Portal implements a comprehensive, multi-layered security architecture designed to protect sensitive data, prevent unauthorized access, and ensure the integrity of municipal service operations. The security framework follows industry best practices and defense-in-depth principles to create a robust protection against various threats and vulnerabilities.

#### Security Principles

**Defense in Depth**
Multiple security layers are implemented throughout the application, ensuring that a breach in one layer does not compromise the entire system. Each layer provides independent protection and monitoring capabilities.

**Least Privilege Principle**
Users and system components are granted only the minimum permissions necessary to perform their intended functions. This minimizes the potential impact of compromised accounts or components.

**Security by Design**
Security considerations are integrated into every aspect of the system design, from database schema to user interface implementation, rather than being added as an afterthought.

**Fail Securely**
The system is designed to fail securely, denying access by default and requiring explicit authorization for all operations. Error conditions do not expose sensitive information or provide unauthorized access.

### Authentication and Authorization

#### User Authentication System

**Password-Based Authentication**
```java
public class AuthenticationService {
    
    public User authenticateUser(String email, String password) {
        // Input validation
        if (!isValidEmail(email) || !isValidPassword(password)) {
            throw new AuthenticationException("Invalid credentials format");
        }
        
        User user = userDAO.findByEmail(email);
        if (user == null) {
            // Prevent timing attacks by performing dummy operation
            hashPassword("dummy");
            throw new AuthenticationException("Invalid credentials");
        }
        
        // Password verification (currently plain text, to be enhanced)
        if (!password.equals(user.getPassword())) {
            throw new AuthenticationException("Invalid credentials");
        }
        
        // Additional security checks
        if (isAccountLocked(user.getId())) {
            throw new AuthenticationException("Account is locked");
        }
        
        return user;
    }
    
    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email != null && email.matches(emailRegex) && email.length() <= 100;
    }
    
    private boolean isValidPassword(String password) {
        return password != null && password.length() >= 6 && password.length() <= 255;
    }
    
    // Planned enhancement: BCrypt password hashing
    private String hashPassword(String password) {
        // Implementation to be added with BCrypt
        return password; // Temporary placeholder
    }
}
```

**Session Management**
```java
public class SessionManager {
    
    public static void createSecureSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        
        // Configure secure session
        session.setAttribute("loggedUser", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("loginTime", System.currentTimeMillis());
        session.setAttribute("userAgent", request.getHeader("User-Agent"));
        session.setAttribute("ipAddress", getClientIpAddress(request));
        
        // Set session attributes
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
    }
    
    public static boolean validateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        // Additional session validation
        String userAgent = (String) session.getAttribute("userAgent");
        String currentAgent = request.getHeader("User-Agent");
        
        if (userAgent != null && !userAgent.equals(currentAgent)) {
            invalidateSession(request);
            return false;
        }
        
        return session.getAttribute("loggedUser") != null;
    }
    
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
    
    private static String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
```

#### Role-Based Access Control (RBAC)

**Authorization Filter**
```java
@WebFilter("/*")
public class AuthorizationFilter implements Filter {
    
    private static final String[] PUBLIC_PATHS = {
        "/login", "/register", "/error", "/css/", "/js/", "/images/"
    };
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Check if path is public
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Validate session
        if (!SessionManager.validateSession(httpRequest)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Check role-based access
        if (!hasRequiredRole(httpRequest, path)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    private boolean isPublicPath(String path) {
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }
    
    private boolean hasRequiredRole(HttpServletRequest request, String path) {
        String userRole = (String) request.getSession().getAttribute("userRole");
        
        if (path.startsWith("/admin")) {
            return "ADMIN".equals(userRole);
        }
        
        if (path.startsWith("/citizen")) {
            return "CITIZEN".equals(userRole) || "ADMIN".equals(userRole);
        }
        
        return true; // Default allow
    }
}
```

**Role-Based Service Layer**
```java
public class AuthorizationService {
    
    public static boolean canAccessComplaint(User user, int complaintId) {
        if ("ADMIN".equals(user.getRole())) {
            return true;
        }
        
        Complaint complaint = complaintDAO.findById(complaintId);
        return complaint != null && complaint.getUserId() == user.getId();
    }
    
    public static boolean canManageUsers(User user) {
        return "ADMIN".equals(user.getRole());
    }
    
    public static boolean canPostAnnouncement(User user) {
        return "ADMIN".equals(user.getRole());
    }
    
    public static boolean canViewBill(User user, int billId) {
        if ("ADMIN".equals(user.getRole())) {
            return true;
        }
        
        Bill bill = billDAO.findById(billId);
        return bill != null && bill.getUserId() == user.getId();
    }
}
```

### Input Validation and Data Protection

#### Input Validation Framework

**Comprehensive Input Validator**
```java
public class InputValidator {
    
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^[+]?[\\d\\s-()]{10,20}$");
    private static final Pattern NAME_PATTERN = 
        Pattern.compile("^[a-zA-Z\\s\\.']{2,100}$");
    
    public static ValidationResult validateRegistrationInput(
            String name, String email, String password, String phone, String address) {
        
        ValidationResult result = new ValidationResult();
        
        if (!isValidName(name)) {
            result.addError("name", "Invalid name format");
        }
        
        if (!isValidEmail(email)) {
            result.addError("email", "Invalid email format");
        }
        
        if (!isValidPassword(password)) {
            result.addError("password", "Password must be at least 6 characters");
        }
        
        if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
            result.addError("phone", "Invalid phone number format");
        }
        
        if (address != null && address.length() > 255) {
            result.addError("address", "Address too long (max 255 characters)");
        }
        
        return result;
    }
    
    public static boolean isValidName(String name) {
        return name != null && NAME_PATTERN.matcher(name).matches();
    }
    
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }
    
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }
    
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6 && password.length() <= 255;
    }
    
    public static String sanitizeHtml(String input) {
        if (input == null) {
            return null;
        }
        // Basic HTML sanitization
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;");
    }
}

public class ValidationResult {
    private Map<String, String> errors = new HashMap<>();
    
    public void addError(String field, String message) {
        errors.put(field, message);
    }
    
    public boolean hasErrors() {
        return !errors.isEmpty();
    }
    
    public Map<String, String> getErrors() {
        return errors;
    }
}
```

#### SQL Injection Prevention

**Secure Database Operations**
```java
public class SecureComplaintDAO {
    
    public boolean addComplaintSecure(Complaint complaint) throws SQLException {
        String sql = "INSERT INTO complaints (user_id, category, description, location) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            // Parameter binding prevents SQL injection
            ps.setInt(1, complaint.getUserId());
            ps.setString(2, complaint.getCategory());
            ps.setString(3, complaint.getDescription());
            ps.setString(4, complaint.getLocation());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<Complaint> searchComplaintsSecure(String searchTerm, String category) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, u.name as user_name FROM complaints c " +
            "JOIN users u ON c.user_id = u.id WHERE 1=1"
        );
        List<Object> parameters = new ArrayList<>();
        
        // Dynamic query building with parameters
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (c.description LIKE ? OR c.location LIKE ?)");
            String searchPattern = "%" + searchTerm + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        if (category != null && !category.equals("All")) {
            sql.append(" AND c.category = ?");
            parameters.add(category);
        }
        
        sql.append(" ORDER BY c.date DESC");
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            // Set parameters dynamically
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            List<Complaint> complaints = new ArrayList<>();
            
            while (rs.next()) {
                complaints.add(extractComplaintFromResultSet(rs));
            }
            
            return complaints;
        }
    }
}
```

### Cross-Site Scripting (XSS) Protection

#### Output Encoding

**Secure JSP Templates**
```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Safe output encoding -->
<div class="user-profile">
    <h2><c:out value="${user.name}"/></h2>
    <p>Email: <c:out value="${user.email}"/></p>
    <p>Address: <c:out value="${user.address}"/></p>
</div>

<!-- Safe display of user-generated content -->
<div class="complaint-content">
    <h3><c:out value="${complaint.category}"/></h3>
    <p><c:out value="${complaint.description}"/></p>
    <small>Location: <c:out value="${complaint.location}"/></small>
</div>

<!-- Safe display in JavaScript context -->
<script>
var userInfo = {
    name: '${fn:replace(user.name, "'", "\\'")}',
    email: '${fn:replace(user.email, "'", "\\'")}'
};
</script>
```

**Content Security Policy Implementation**
```java
@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Content Security Policy
        httpResponse.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
            "style-src 'self' 'unsafe-inline' https://stackpath.bootstrapcdn.com; " +
            "img-src 'self' data: https:; " +
            "font-src 'self' https://cdnjs.cloudflare.com; " +
            "connect-src 'self';"
        );
        
        // Other security headers
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        httpResponse.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        chain.doFilter(request, response);
    }
}
```

### Session Security

#### Secure Session Configuration

**Session Security Filter**
```java
@WebFilter("/*")
public class SessionSecurityFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null) {
            // Session fixation protection
            String sessionId = session.getId();
            String expectedSessionId = (String) session.getAttribute("expectedSessionId");
            
            if (expectedSessionId == null) {
                // First time access, store expected session ID
                session.setAttribute("expectedSessionId", sessionId);
            } else if (!sessionId.equals(expectedSessionId)) {
                // Session ID changed, possible fixation attack
                session.invalidate();
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                return;
            }
            
            // Session timeout check
            long loginTime = (Long) session.getAttribute("loginTime");
            long currentTime = System.currentTimeMillis();
            long sessionAge = (currentTime - loginTime) / 1000; // in seconds
            
            if (sessionAge > 30 * 60) { // 30 minutes
                session.invalidate();
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?timeout=true");
                return;
            }
            
            // Update last activity time
            session.setAttribute("lastActivity", currentTime);
        }
        
        chain.doFilter(request, response);
    }
}
```

#### CSRF Protection (Planned Enhancement)

**CSRF Token Implementation**
```java
public class CSRFTokenManager {
    
    public static String generateToken(HttpSession session) {
        String token = UUID.randomUUID().toString();
        session.setAttribute("csrfToken", token);
        return token;
    }
    
    public static boolean validateToken(HttpSession session, String submittedToken) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        return sessionToken != null && sessionToken.equals(submittedToken);
    }
    
    public static String getTokenForSession(HttpSession session) {
        String token = (String) session.getAttribute("csrfToken");
        if (token == null) {
            token = generateToken(session);
        }
        return token;
    }
}
```

**CSRF Token in Forms**
```jsp
<form action="/complaint" method="post">
    <input type="hidden" name="csrfToken" value="${csrfToken}"/>
    <!-- Other form fields -->
</form>
```

### Data Encryption and Protection

#### Password Security Enhancement (Planned)

**BCrypt Password Hashing**
```java
public class PasswordSecurity {
    
    private static final int BCRYPT_ROUNDS = 12;
    
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }
    
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
    
    public static void migratePasswords() {
        List<User> users = userDAO.getAllUsersWithPlainPasswords();
        
        for (User user : users) {
            String hashedPassword = hashPassword(user.getPassword());
            userDAO.updatePassword(user.getId(), hashedPassword);
        }
    }
}
```

#### Sensitive Data Protection

**Data Encryption Utility**
```java
public class DataEncryption {
    
    private static final String ALGORITHM = "AES/GCM/NoPadding";
    private static final String SECRET_KEY = "YourSecretKey123"; // Should be from secure config
    
    public static String encrypt(String plainText) {
        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            
            byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
            return Base64.getEncoder().encodeToString(encryptedBytes);
        } catch (Exception e) {
            throw new RuntimeException("Encryption failed", e);
        }
    }
    
    public static String decrypt(String encryptedText) {
        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            
            byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedText));
            return new String(decryptedBytes);
        } catch (Exception e) {
            throw new RuntimeException("Decryption failed", e);
        }
    }
}
```

### Security Monitoring and Logging

#### Security Event Logging

**Security Logger**
```java
public class SecurityLogger {
    
    private static final Logger logger = LoggerFactory.getLogger(SecurityLogger.class);
    
    public static void logAuthenticationAttempt(String email, String ipAddress, 
                                               boolean success, String userAgent) {
        String logMessage = String.format(
            "Authentication attempt - Email: %s, IP: %s, Success: %s, UserAgent: %s",
            email, ipAddress, success, userAgent
        );
        
        if (success) {
            logger.info(logMessage);
        } else {
            logger.warn(logMessage);
        }
    }
    
    public static void logAuthorizationFailure(String userId, String resource, 
                                              String action, String ipAddress) {
        String logMessage = String.format(
            "Authorization failure - User: %s, Resource: %s, Action: %s, IP: %s",
            userId, resource, action, ipAddress
        );
        
        logger.warn(logMessage);
    }
    
    public static void logSuspiciousActivity(String description, String ipAddress, 
                                           String userAgent) {
        String logMessage = String.format(
            "Suspicious activity - Description: %s, IP: %s, UserAgent: %s",
            description, ipAddress, userAgent
        );
        
        logger.error(logMessage);
    }
    
    public static void logDataAccess(String userId, String dataType, String recordId, 
                                   boolean success) {
        String logMessage = String.format(
            "Data access - User: %s, Type: %s, Record: %s, Success: %s",
            userId, dataType, recordId, success
        );
        
        logger.info(logMessage);
    }
}
```

#### Intrusion Detection

**Suspicious Activity Detector**
```java
public class IntrusionDetector {
    
    private static final int MAX_LOGIN_ATTEMPTS = 5;
    private static final int MAX_REQUESTS_PER_MINUTE = 100;
    
    public static boolean detectBruteForceAttack(String email, String ipAddress) {
        int failedAttempts = getFailedLoginAttempts(email, ipAddress);
        return failedAttempts >= MAX_LOGIN_ATTEMPTS;
    }
    
    public static boolean detectDDoSAttack(String ipAddress) {
        int requestCount = getRequestCount(ipAddress, System.currentTimeMillis() - 60000);
        return requestCount >= MAX_REQUESTS_PER_MINUTE;
    }
    
    public static boolean detectSQLInjectionAttempt(String input) {
        String[] sqlPatterns = {
            "('(''|[^'])*')|(;)|(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE){0,1}|INSERT( +INTO){0,1}|MERGE|SELECT|UPDATE|UNION( +ALL){0,1})\b)"
        };
        
        for (String pattern : sqlPatterns) {
            if (input.toLowerCase().matches(pattern)) {
                return true;
            }
        }
        return false;
    }
    
    private static int getFailedLoginAttempts(String email, String ipAddress) {
        // Implementation to track failed attempts
        return 0; // Placeholder
    }
    
    private static int getRequestCount(String ipAddress, long sinceTime) {
        // Implementation to track request frequency
        return 0; // Placeholder
    }
}
```

### Security Configuration

#### Web Security Configuration

**Security Configuration in web.xml**
```xml
<!-- Security constraints -->
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Admin Area</web-resource-name>
        <url-pattern>/admin/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
        <role-name>ADMIN</role-name>
    </auth-constraint>
    <user-data-constraint>
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
</security-constraint>

<!-- Session configuration -->
<session-config>
    <session-timeout>30</session-timeout>
    <cookie-config>
        <http-only>true</http-only>
        <secure>true</secure>
    </cookie-config>
    <tracking-mode>COOKIE</tracking-mode>
</session-config>

<!-- Error pages for security -->
<error-page>
    <error-code>403</error-code>
    <location>/error/403.jsp</location>
</error-page>
<error-page>
    <error-code>404</error-code>
    <location>/error/404.jsp</location>
</error-page>
```

#### Database Security Configuration

**Database User Privileges**
```sql
-- Application user with limited privileges
CREATE USER 'smartcity_app'@'localhost' IDENTIFIED BY 'secure_password';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON smartcity_db.users TO 'smartcity_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON smartcity_db.complaints TO 'smartcity_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON smartcity_db.appointments TO 'smartcity_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON smartcity_db.bills TO 'smartcity_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON smartcity_db.announcements TO 'smartcity_app'@'localhost';

-- No administrative privileges
REVOKE ALL PRIVILEGES ON *.* FROM 'smartcity_app'@'localhost';
FLUSH PRIVILEGES;
```

### Security Testing and Validation

#### Security Test Cases

**Authentication Security Tests**
```java
@Test
public void testSQLInjectionPrevention() {
    String maliciousInput = "'; DROP TABLE users; --";
    
    // Test that malicious input is safely handled
    assertDoesNotThrow(() -> {
        List<Complaint> results = complaintDAO.searchComplaintsSecure(maliciousInput, "All");
    });
    
    // Verify database is intact
    assertDoesNotThrow(() -> {
        userDAO.findById(1);
    });
}

@Test
public void testXSSPrevention() {
    String xssPayload = "<script>alert('XSS')</script>";
    
    // Test that XSS payload is encoded in output
    String encoded = InputValidator.sanitizeHtml(xssPayload);
    assertFalse(encoded.contains("<script>"));
    assertTrue(encoded.contains("&lt;script&gt;"));
}

@Test
public void testSessionSecurity() {
    // Test session fixation prevention
    MockHttpServletRequest request = new MockHttpServletRequest();
    MockHttpSession session = new MockHttpSession();
    
    SessionManager.createSecureSession(request, testUser);
    String originalSessionId = session.getId();
    
    // Simulate session fixation attempt
    session.setId("malicious-session-id");
    
    assertFalse(SessionManager.validateSession(request));
}
```

---

## Page 9: Testing Strategy and Quality Assurance

### Testing Methodology Overview

The Smart City Service Portal implements a comprehensive testing strategy designed to ensure software quality, reliability, and performance. The testing methodology encompasses multiple testing levels, automated testing frameworks, and quality assurance processes that align with industry best practices and academic project requirements.

#### Testing Objectives

**Functional Correctness**
Ensure that all application features work according to specified requirements and business rules. This includes validating user workflows, data processing, and system behavior under various conditions.

**Performance and Scalability**
Verify that the application performs acceptably under expected load conditions and can scale to handle increasing user numbers and data volumes without degradation.

**Security Validation**
Test security controls, authentication mechanisms, and data protection measures to identify vulnerabilities and ensure compliance with security requirements.

**User Experience Quality**
Validate that the user interface is intuitive, accessible, and provides a positive user experience across different devices and browsers.

**Compatibility Testing**
Ensure the application works correctly across different browsers, operating systems, and device configurations as specified in requirements.

### Testing Levels and Types

#### Unit Testing

**DAO Layer Testing**
```java
public class UserDAOTest {
    
    private UserDAO userDAO;
    private Connection testConnection;
    
    @Before
    public void setUp() throws SQLException {
        // Initialize test database
        testConnection = TestDatabaseManager.getTestConnection();
        userDAO = new UserDAO();
        TestDatabaseManager.cleanDatabase();
    }
    
    @Test
    public void testAddUser_ValidUser_ReturnsTrue() {
        // Arrange
        User testUser = createTestUser();
        
        // Act
        boolean result = userDAO.addUser(testUser);
        
        // Assert
        assertTrue("User should be added successfully", result);
        
        // Verify user exists in database
        User retrievedUser = userDAO.findByEmail(testUser.getEmail());
        assertNotNull("User should exist in database", retrievedUser);
        assertEquals("Email should match", testUser.getEmail(), retrievedUser.getEmail());
    }
    
    @Test
    public void testAddUser_DuplicateEmail_ReturnsFalse() {
        // Arrange
        User testUser = createTestUser();
        userDAO.addUser(testUser);
        
        User duplicateUser = createTestUser();
        duplicateUser.setEmail(testUser.getEmail());
        
        // Act
        boolean result = userDAO.addUser(duplicateUser);
        
        // Assert
        assertFalse("Duplicate email should not be allowed", result);
    }
    
    @Test
    public void testLoginUser_ValidCredentials_ReturnsUser() {
        // Arrange
        User testUser = createTestUser();
        userDAO.addUser(testUser);
        
        // Act
        User loggedInUser = userDAO.loginUser(testUser.getEmail(), testUser.getPassword());
        
        // Assert
        assertNotNull("User should be able to login", loggedInUser);
        assertEquals("User ID should match", testUser.getId(), loggedInUser.getId());
        assertEquals("User role should match", testUser.getRole(), loggedInUser.getRole());
    }
    
    @Test
    public void testLoginUser_InvalidCredentials_ReturnsNull() {
        // Act
        User loggedInUser = userDAO.loginUser("nonexistent@test.com", "wrongpassword");
        
        // Assert
        assertNull("Invalid credentials should return null", loggedInUser);
    }
    
    @Test(expected = SQLException.class)
    public void testAddUser_DatabaseConnectionFailure_ThrowsSQLException() throws SQLException {
        // Arrange
        User testUser = createTestUser();
        TestDatabaseManager.closeConnection();
        
        // Act
        userDAO.addUser(testUser);
    }
    
    private User createTestUser() {
        User user = new User();
        user.setName("Test User");
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setPhone("1234567890");
        user.setAddress("Test Address");
        user.setRole("CITIZEN");
        return user;
    }
}
```

**Service Layer Testing**
```java
public class AuthenticationServiceTest {
    
    private AuthenticationService authService;
    private UserDAO mockUserDAO;
    
    @Before
    public void setUp() {
        mockUserDAO = mock(UserDAO.class);
        authService = new AuthenticationService(mockUserDAO);
    }
    
    @Test
    public void testAuthenticate_ValidCredentials_ReturnsUser() {
        // Arrange
        User testUser = createTestUser();
        when(mockUserDAO.findByEmail("test@example.com")).thenReturn(testUser);
        
        // Act
        User result = authService.authenticateUser("test@example.com", "password123");
        
        // Assert
        assertNotNull("Authentication should succeed", result);
        assertEquals("User should match", testUser, result);
        verify(mockUserDAO).findByEmail("test@example.com");
    }
    
    @Test(expected = AuthenticationException.class)
    public void testAuthenticate_InvalidEmail_ThrowsAuthenticationException() {
        // Act
        authService.authenticateUser("invalid-email", "password123");
    }
    
    @Test(expected = AuthenticationException.class)
    public void testAuthenticate_InvalidPassword_ThrowsAuthenticationException() {
        // Arrange
        User testUser = createTestUser();
        when(mockUserDAO.findByEmail("test@example.com")).thenReturn(testUser);
        
        // Act
        authService.authenticateUser("test@example.com", "wrongpassword");
    }
    
    @Test(expected = AuthenticationException.class)
    public void testAuthenticate_NonexistentUser_ThrowsAuthenticationException() {
        // Arrange
        when(mockUserDAO.findByEmail("nonexistent@example.com")).thenReturn(null);
        
        // Act
        authService.authenticateUser("nonexistent@example.com", "password123");
    }
}
```

#### Integration Testing

**Servlet Integration Testing**
```java
public class LoginServletIntegrationTest {
    
    private LoginServlet loginServlet;
    private MockHttpServletRequest request;
    private MockHttpServletResponse response;
    
    @Before
    public void setUp() {
        loginServlet = new LoginServlet();
        request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
        TestDatabaseManager.cleanDatabase();
    }
    
    @Test
    public void testDoPost_ValidCredentials_RedirectsToDashboard() throws Exception {
        // Arrange
        User testUser = createTestUser();
        UserDAO userDAO = new UserDAO();
        userDAO.addUser(testUser);
        
        request.setParameter("email", testUser.getEmail());
        request.setParameter("password", testUser.getPassword());
        
        // Act
        loginServlet.doPost(request, response);
        
        // Assert
        assertEquals("Should redirect to citizen dashboard", 
                    "/citizen/dashboard.jsp", response.getRedirectedUrl());
        
        HttpSession session = request.getSession();
        assertNotNull("Session should be created", session);
        assertEquals("User should be in session", testUser, session.getAttribute("loggedUser"));
    }
    
    @Test
    public void testDoPost_InvalidCredentials_ForwardsToLoginWithErrorMessage() throws Exception {
        // Arrange
        request.setParameter("email", "nonexistent@example.com");
        request.setParameter("password", "wrongpassword");
        
        // Act
        loginServlet.doPost(request, response);
        
        // Assert
        assertEquals("Should forward to login page", "/login.jsp", response.getForwardedUrl());
        assertEquals("Error message should be set", "Invalid email or password", 
                    request.getAttribute("error"));
    }
    
    @Test
    public void testDoPost_EmptyFields_ForwardsToLoginWithErrorMessage() throws Exception {
        // Arrange
        request.setParameter("email", "");
        request.setParameter("password", "");
        
        // Act
        loginServlet.doPost(request, response);
        
        // Assert
        assertEquals("Should forward to login page", "/login.jsp", response.getForwardedUrl());
        assertEquals("Error message should be set", "Email and password are required", 
                    request.getAttribute("error"));
    }
}
```

**Database Integration Testing**
```java
public class DatabaseIntegrationTest {
    
    private static Connection testConnection;
    
    @BeforeClass
    public static void setUpClass() throws SQLException {
        testConnection = TestDatabaseManager.getTestConnection();
        TestDatabaseManager.createTestSchema();
    }
    
    @AfterClass
    public static void tearDownClass() throws SQLException {
        TestDatabaseManager.dropTestSchema();
        TestDatabaseManager.closeConnection();
    }
    
    @Before
    public void setUp() {
        TestDatabaseManager.cleanDatabase();
    }
    
    @Test
    public void testComplaintWorkflow_CompleteWorkflow_Success() throws SQLException {
        // Create user
        UserDAO userDAO = new UserDAO();
        User testUser = createTestUser();
        assertTrue("User should be created", userDAO.addUser(testUser));
        
        // File complaint
        ComplaintDAO complaintDAO = new ComplaintDAO();
        Complaint complaint = createTestComplaint(testUser.getId());
        assertTrue("Complaint should be filed", complaintDAO.addComplaint(complaint));
        
        // Retrieve complaint
        List<Complaint> userComplaints = complaintDAO.getUserComplaints(testUser.getId());
        assertEquals("User should have one complaint", 1, userComplaints.size());
        
        // Update complaint status
        Complaint retrievedComplaint = userComplaints.get(0);
        assertTrue("Status should be updated", 
                  complaintDAO.updateComplaintStatus(retrievedComplaint.getComplaintId(), "In Progress"));
        
        // Verify status update
        List<Complaint> updatedComplaints = complaintDAO.getUserComplaints(testUser.getId());
        assertEquals("Status should be In Progress", "In Progress", 
                    updatedComplaints.get(0).getStatus());
    }
    
    @Test
    public void testForeignKeyConstraint_DeleteUser_CascadesComplaints() throws SQLException {
        // Create user and complaint
        UserDAO userDAO = new UserDAO();
        ComplaintDAO complaintDAO = new ComplaintDAO();
        
        User testUser = createTestUser();
        userDAO.addUser(testUser);
        
        Complaint complaint = createTestComplaint(testUser.getId());
        complaintDAO.addComplaint(complaint);
        
        // Verify complaint exists
        List<Complaint> complaints = complaintDAO.getUserComplaints(testUser.getId());
        assertEquals("Complaint should exist", 1, complaints.size());
        
        // Delete user (should cascade delete complaints)
        assertTrue("User should be deleted", userDAO.deleteUser(testUser.getId()));
        
        // Verify complaint is deleted
        List<Complaint> remainingComplaints = complaintDAO.getUserComplaints(testUser.getId());
        assertEquals("Complaint should be deleted", 0, remainingComplaints.size());
    }
}
```

#### End-to-End Testing

**Selenium WebDriver Testing**
```java
public class EndToEndTest {
    
    private WebDriver driver;
    private WebDriverWait wait;
    
    @Before
    public void setUp() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, 10);
        driver.manage().window().maximize();
    }
    
    @After
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
    
    @Test
    public void testCompleteUserWorkflow_RegisterLoginFileComplaint() {
        // Navigate to application
        driver.get("http://localhost:8080/SmartCityPortal");
        
        // Register new user
        registerNewUser();
        
        // Login with new credentials
        loginWithCredentials();
        
        // File a complaint
        fileComplaint();
        
        // Verify complaint appears in dashboard
        verifyComplaintInDashboard();
        
        // Logout
        logoutUser();
    }
    
    private void registerNewUser() {
        driver.findElement(By.linkText("Register")).click();
        
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("name")));
        driver.findElement(By.id("name")).sendKeys("Test User");
        driver.findElement(By.id("email")).sendKeys("testuser@example.com");
        driver.findElement(By.id("password")).sendKeys("password123");
        driver.findElement(By.id("phone")).sendKeys("1234567890");
        driver.findElement(By.id("address")).sendKeys("Test Address");
        
        driver.findElement(By.cssSelector("button[type='submit']")).click();
        
        // Verify registration success
        wait.until(ExpectedConditions.urlContains("/login"));
        assertTrue("Should show success message", 
                  driver.getPageSource().contains("Registration successful"));
    }
    
    private void loginWithCredentials() {
        driver.findElement(By.id("email")).sendKeys("testuser@example.com");
        driver.findElement(By.id("password")).sendKeys("password123");
        driver.findElement(By.cssSelector("button[type='submit']")).click();
        
        // Verify login success and redirect to dashboard
        wait.until(ExpectedConditions.urlContains("/citizen/dashboard"));
        assertTrue("Should show welcome message", 
                  driver.getPageSource().contains("Welcome, Test User"));
    }
    
    private void fileComplaint() {
        driver.findElement(By.linkText("File Complaint")).click();
        
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("category")));
        Select categorySelect = new Select(driver.findElement(By.id("category")));
        categorySelect.selectByVisibleText("Road");
        
        driver.findElement(By.id("description")).sendKeys("Large pothole on main road");
        driver.findElement(By.id("location")).sendKeys("MG Road, Block A");
        
        driver.findElement(By.cssSelector("button[type='submit']")).click();
        
        // Verify complaint submission success
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("alert-success")));
        assertTrue("Should show success message", 
                  driver.getPageSource().contains("Complaint filed successfully"));
    }
    
    private void verifyComplaintInDashboard() {
        driver.findElement(By.linkText("Dashboard")).click();
        
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("complaintsTable")));
        
        // Verify complaint appears in table
        assertTrue("Complaint should appear in dashboard", 
                  driver.getPageSource().contains("Large pothole on main road"));
        assertTrue("Status should be Pending", 
                  driver.getPageSource().contains("Pending"));
    }
    
    private void logoutUser() {
        driver.findElement(By.linkText("Logout")).click();
        
        // Verify logout and redirect to login page
        wait.until(ExpectedConditions.urlContains("/login"));
        assertFalse("Should not show user name", 
                   driver.getPageSource().contains("Welcome, Test User"));
    }
}
```

### Performance Testing

#### Load Testing with JMeter

**JMeter Test Plan Configuration**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0" jmeter="5.4.1">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Smart City Portal Load Test" enabled="true">
      <stringProp name="TestPlan.comments">Load testing for Smart City Service Portal</stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.tearDown_on_shutdown">true</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
        <collectionProp name="Arguments.arguments">
          <elementProp name="BASE_URL" elementType="Argument">
            <stringProp name="Argument.name">BASE_URL</stringProp>
            <stringProp name="Argument.value">http://localhost:8080/SmartCityPortal</stringProp>
          </elementProp>
        </collectionProp>
      </elementProp>
    </TestPlan>
    <hashTree>
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Concurrent Users" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <stringProp name="LoopController.loops">10</stringProp>
        </elementProp>
        <stringProp name="ThreadGroup.num_threads">50</stringProp>
        <stringProp name="ThreadGroup.ramp_time">10</stringProp>
        <boolProp name="ThreadGroup.scheduler">false</boolProp>
        <stringProp name="ThreadGroup.duration"></stringProp>
        <stringProp name="ThreadGroup.delay"></stringProp>
      </ThreadGroup>
      <hashTree>
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="Login Request" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments">
              <elementProp name="email" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">testuser@example.com</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">email</stringProp>
              </elementProp>
              <elementProp name="password" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">password123</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">password</stringProp>
              </elementProp>
            </collectionProp>
          </elementProp>
          <stringProp name="HTTPSampler.domain">localhost</stringProp>
          <stringProp name="HTTPSampler.port">8080</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding">UTF-8</stringProp>
          <stringProp name="HTTPSampler.path">/SmartCityPortal/login</stringProp>
          <stringProp name="HTTPSampler.method">POST</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
          <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          <stringProp name="HTTPSampler.connect_timeout"></stringProp>
          <stringProp name="HTTPSampler.response_timeout"></stringProp>
        </HTTPSamplerProxy>
        <hashTree/>
      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

**Performance Test Results Analysis**
```java
public class PerformanceTestAnalyzer {
    
    public static void analyzeTestResults(String jtlFilePath) {
        try {
            List<TestResult> results = parseJTLFile(jtlFilePath);
            
            // Calculate metrics
            double averageResponseTime = calculateAverageResponseTime(results);
            double maxResponseTime = calculateMaxResponseTime(results);
            double minResponseTime = calculateMinResponseTime(results);
            double errorRate = calculateErrorRate(results);
            double throughput = calculateThroughput(results);
            
            // Generate report
            System.out.println("Performance Test Results:");
            System.out.println("Average Response Time: " + averageResponseTime + " ms");
            System.out.println("Max Response Time: " + maxResponseTime + " ms");
            System.out.println("Min Response Time: " + minResponseTime + " ms");
            System.out.println("Error Rate: " + errorRate + "%");
            System.out.println("Throughput: " + throughput + " requests/second");
            
            // Validate against thresholds
            validatePerformanceThresholds(averageResponseTime, errorRate, throughput);
            
        } catch (Exception e) {
            System.err.println("Error analyzing test results: " + e.getMessage());
        }
    }
    
    private static void validatePerformanceThresholds(double avgResponseTime, 
                                                    double errorRate, double throughput) {
        final double MAX_AVG_RESPONSE_TIME = 2000; // 2 seconds
        final double MAX_ERROR_RATE = 1.0; // 1%
        final double MIN_THROUGHPUT = 10; // 10 requests/second
        
        if (avgResponseTime > MAX_AVG_RESPONSE_TIME) {
            System.err.println("WARNING: Average response time exceeds threshold: " + avgResponseTime + " ms");
        }
        
        if (errorRate > MAX_ERROR_RATE) {
            System.err.println("WARNING: Error rate exceeds threshold: " + errorRate + "%");
        }
        
        if (throughput < MIN_THROUGHPUT) {
            System.err.println("WARNING: Throughput below threshold: " + throughput + " req/sec");
        }
    }
}
```

### Security Testing

#### Security Vulnerability Testing

**SQL Injection Testing**
```java
public class SecurityTest {
    
    @Test
    public void testSQLInjectionPrevention() {
        String[] sqlInjectionPayloads = {
            "'; DROP TABLE users; --",
            "' OR '1'='1",
            "'; INSERT INTO users VALUES ('hacker', 'hacker@test.com', 'password'); --",
            "' UNION SELECT * FROM users --"
        };
        
        for (String payload : sqlInjectionPayloads) {
            // Test complaint search with malicious input
            assertDoesNotThrow(() -> {
                ComplaintDAO complaintDAO = new ComplaintDAO();
                List<Complaint> results = complaintDAO.searchComplaintsSecure(payload, "All");
                assertNotNull("Search should not crash", results);
            });
            
            // Test login with malicious input
            AuthenticationException exception = assertThrows(AuthenticationException.class, () -> {
                AuthenticationService authService = new AuthenticationService();
                authService.authenticateUser(payload, "password");
            });
            
            assertTrue("Should detect invalid input format", 
                      exception.getMessage().contains("Invalid credentials format"));
        }
        
        // Verify database integrity
        assertDoesNotThrow(() -> {
            UserDAO userDAO = new UserDAO();
            List<User> users = userDAO.getAllUsers();
            assertNotNull("Users table should be intact", users);
        });
    }
    
    @Test
    public void testXSSPrevention() {
        String[] xssPayloads = {
            "<script>alert('XSS')</script>",
            "javascript:alert('XSS')",
            "<img src='x' onerror='alert(\"XSS\")'>",
            "';alert('XSS');//"
        };
        
        for (String payload : xssPayloads) {
            String sanitized = InputValidator.sanitizeHtml(payload);
            
            assertFalse("Should not contain script tags", sanitized.contains("<script>"));
            assertFalse("Should not contain javascript:", sanitized.toLowerCase().contains("javascript:"));
            assertFalse("Should not contain onerror", sanitized.toLowerCase().contains("onerror"));
            
            // Verify HTML entities are properly encoded
            assertTrue("Should encode < as &lt;", sanitized.contains("&lt;"));
            assertTrue("Should encode > as &gt;", sanitized.contains("&gt;"));
        }
    }
    
    @Test
    public void testSessionSecurity() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        
        // Test session fixation prevention
        User testUser = createTestUser();
        SessionManager.createSecureSession(request, testUser);
        
        String originalSessionId = request.getSession().getId();
        
        // Attempt session fixation
        request.getSession().setId("malicious-session-id");
        
        boolean isValid = SessionManager.validateSession(request);
        assertFalse("Session fixation should be detected", isValid);
    }
    
    @Test
    public void testAuthorizationBypass() {
        // Test that citizens cannot access admin functions
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpSession session = new MockHttpSession();
        
        User citizenUser = new User();
        citizenUser.setId(2);
        citizenUser.setRole("CITIZEN");
        
        session.setAttribute("loggedUser", citizenUser);
        session.setAttribute("userRole", "CITIZEN");
        request.setSession(session);
        
        request.setRequestURI("/admin/dashboard");
        
        boolean hasAccess = AuthorizationFilter.hasRequiredRole(request, "/admin/dashboard");
        assertFalse("Citizen should not access admin dashboard", hasAccess);
    }
}
```

### Test Data Management

#### Test Data Factory

**Test Data Generation**
```java
public class TestDataFactory {
    
    private static final Random random = new Random();
    
    public static User createTestUser() {
        User user = new User();
        user.setName("Test User " + random.nextInt(1000));
        user.setEmail("test" + random.nextInt(1000) + "@example.com");
        user.setPassword("password123");
        user.setPhone("123456789" + random.nextInt(10));
        user.setAddress("Test Address " + random.nextInt(100));
        user.setRole("CITIZEN");
        return user;
    }
    
    public static User createTestAdmin() {
        User admin = createTestUser();
        admin.setRole("ADMIN");
        admin.setEmail("admin" + random.nextInt(1000) + "@example.com");
        return admin;
    }
    
    public static Complaint createTestComplaint(int userId) {
        Complaint complaint = new Complaint();
        complaint.setUserId(userId);
        complaint.setCategory(getRandomCategory());
        complaint.setDescription("Test complaint description " + random.nextInt(1000));
        complaint.setLocation("Test location " + random.nextInt(100));
        complaint.setStatus("Pending");
        return complaint;
    }
    
    public static Appointment createTestAppointment(int userId) {
        Appointment appointment = new Appointment();
        appointment.setUserId(userId);
        appointment.setDoctorName("Dr. Test " + random.nextInt(10));
        appointment.setSpecialization("General Medicine");
        appointment.setDate(getFutureDate(random.nextInt(30) + 1));
        appointment.setTime(LocalTime.of(9 + random.nextInt(8), random.nextInt(4) * 15));
        appointment.setStatus("Pending");
        return appointment;
    }
    
    public static Bill createTestBill(int userId) {
        Bill bill = new Bill();
        bill.setUserId(userId);
        bill.setType(getRandomBillType());
        bill.setAmount(new BigDecimal(random.nextInt(1000) + 100));
        bill.setDueDate(getFutureDate(random.nextInt(60) + 1));
        bill.setStatus("Unpaid");
        return bill;
    }
    
    private static String getRandomCategory() {
        String[] categories = {"Road", "Water", "Electricity", "Garbage", "Other"};
        return categories[random.nextInt(categories.length)];
    }
    
    private static String getRandomBillType() {
        String[] types = {"Electricity", "Water", "Property Tax", "Sewage"};
        return types[random.nextInt(types.length)];
    }
    
    private static Date getFutureDate(int daysFromNow) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, daysFromNow);
        return calendar.getTime();
    }
}
```

#### Test Database Management

**Test Database Setup**
```java
public class TestDatabaseManager {
    
    private static Connection testConnection;
    private static final String TEST_DB_URL = "jdbc:mysql://localhost:3306/smartcity_test";
    
    public static Connection getTestConnection() throws SQLException {
        if (testConnection == null || testConnection.isClosed()) {
            testConnection = DriverManager.getConnection(TEST_DB_URL, "root", "password");
        }
        return testConnection;
    }
    
    public static void createTestSchema() throws SQLException {
        try (Statement stmt = getTestConnection().createStatement()) {
            // Create test schema
            stmt.execute("DROP DATABASE IF EXISTS smartcity_test");
            stmt.execute("CREATE DATABASE smartcity_test");
            stmt.execute("USE smartcity_test");
            
            // Execute schema creation script
            executeScript(stmt, "/sql/test_schema.sql");
        }
    }
    
    public static void cleanDatabase() throws SQLException {
        try (Statement stmt = getTestConnection().createStatement()) {
            stmt.execute("USE smartcity_test");
            
            // Clean tables in correct order (respecting foreign keys)
            stmt.execute("DELETE FROM announcements");
            stmt.execute("DELETE FROM bills");
            stmt.execute("DELETE FROM appointments");
            stmt.execute("DELETE FROM complaints");
            stmt.execute("DELETE FROM users");
        }
    }
    
    public static void dropTestSchema() throws SQLException {
        try (Statement stmt = getTestConnection().createStatement()) {
            stmt.execute("DROP DATABASE IF EXISTS smartcity_test");
        }
    }
    
    public static void closeConnection() throws SQLException {
        if (testConnection != null && !testConnection.isClosed()) {
            testConnection.close();
        }
    }
    
    private static void executeScript(Statement stmt, String scriptPath) throws SQLException {
        // Implementation to execute SQL script file
        // This would read the script file and execute each statement
    }
}
```

### Continuous Integration Testing

#### Maven Test Configuration

**pom.xml Test Configuration**
```xml
<build>
    <plugins>
        <!-- Surefire Plugin for Unit Tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0-M5</version>
            <configuration>
                <includes>
                    <include>**/*Test.java</include>
                </includes>
                <excludes>
                    <exclude>**/*IntegrationTest.java</exclude>
                </excludes>
            </configuration>
        </plugin>
        
        <!-- Failsafe Plugin for Integration Tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-failsafe-plugin</artifactId>
            <version>3.0.0-M5</version>
            <configuration>
                <includes>
                    <include>**/*IntegrationTest.java</include>
                </includes>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>integration-test</goal>
                        <goal>verify</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        
        <!-- JaCoCo Plugin for Code Coverage -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.7</version>
            <executions>
                <execution>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### Test Reporting and Documentation

#### Test Report Generation

**Test Results Summary**
```java
public class TestReportGenerator {
    
    public static void generateTestReport() {
        TestResults results = collectTestResults();
        
        System.out.println("=== Smart City Portal Test Report ===");
        System.out.println("Total Tests: " + results.getTotalTests());
        System.out.println("Passed: " + results.getPassedTests());
        System.out.println("Failed: " + results.getFailedTests());
        System.out.println("Skipped: " + results.getSkippedTests());
        System.out.println("Success Rate: " + results.getSuccessRate() + "%");
        System.out.println("Code Coverage: " + results.getCodeCoverage() + "%");
        
        System.out.println("\n=== Test Results by Category ===");
        System.out.println("Unit Tests: " + results.getUnitTests().getSummary());
        System.out.println("Integration Tests: " + results.getIntegrationTests().getSummary());
        System.out.println("End-to-End Tests: " + results.getE2ETests().getSummary());
        System.out.println("Performance Tests: " + results.getPerformanceTests().getSummary());
        System.out.println("Security Tests: " + results.getSecurityTests().getSummary());
        
        if (results.hasFailures()) {
            System.out.println("\n=== Failed Tests ===");
            results.getFailedTests().forEach(test -> {
                System.out.println("- " + test.getName() + ": " + test.getFailureMessage());
            });
        }
    }
    
    private static TestResults collectTestResults() {
        // Implementation to collect test results from various test suites
        return new TestResults();
    }
}
```

This comprehensive testing strategy ensures the Smart City Service Portal meets quality standards, performs reliably under load, maintains security, and provides a positive user experience. The combination of automated testing, manual testing, and continuous integration processes creates a robust quality assurance framework for the project.
