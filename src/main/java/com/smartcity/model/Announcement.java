package com.smartcity.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "announcements")
public class Announcement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(length = 20)
    private String category = "General";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "posted_by")
    private User postedBy;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Transient
    private String postedByName;

    public Announcement() {}

    // Getters and Setters
    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public String getTitle()                        { return title; }
    public void setTitle(String title)              { this.title = title; }

    public String getContent()                      { return content; }
    public void setContent(String content)          { this.content = content; }

    public String getCategory()                     { return category; }
    public void setCategory(String category)        { this.category = category; }

    public User getPostedBy()                       { return postedBy; }
    public void setPostedBy(User postedBy)          { this.postedBy = postedBy; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getPostedByName() {
        if (postedByName != null) return postedByName;
        if (postedBy != null) return postedBy.getName();
        return "System";
    }
    public void setPostedByName(String name)        { this.postedByName = name; }
}
