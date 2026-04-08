package model;

import java.sql.Timestamp;

public class Announcement {
    private int id;
    private String title;
    private String content;
    private String category;
    private int postedBy;
    private Timestamp createdAt;
    // For display
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

    public int getPostedBy()                        { return postedBy; }
    public void setPostedBy(int postedBy)           { this.postedBy = postedBy; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)   { this.createdAt = createdAt; }

    public String getPostedByName()                 { return postedByName; }
    public void setPostedByName(String name)        { this.postedByName = name; }
}
