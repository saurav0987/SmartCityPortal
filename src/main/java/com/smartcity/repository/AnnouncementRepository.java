package com.smartcity.repository;

import com.smartcity.model.Announcement;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AnnouncementRepository extends JpaRepository<Announcement, Integer> {
    List<Announcement> findAllByOrderByCreatedAtDesc();
}
