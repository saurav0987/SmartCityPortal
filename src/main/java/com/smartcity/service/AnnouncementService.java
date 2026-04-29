package com.smartcity.service;

import com.smartcity.model.Announcement;
import com.smartcity.repository.AnnouncementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AnnouncementService {

    @Autowired
    private AnnouncementRepository announcementRepository;

    public Announcement save(Announcement a) {
        return announcementRepository.save(a);
    }

    public List<Announcement> getAll() {
        return announcementRepository.findAllByOrderByCreatedAtDesc();
    }

    public void delete(int id) {
        announcementRepository.deleteById(id);
    }

    public long getTotalCount() {
        return announcementRepository.count();
    }
}
