package com.smartcity.service;

import com.smartcity.model.Complaint;
import com.smartcity.model.User;
import com.smartcity.repository.ComplaintRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ComplaintService {

    @Autowired
    private ComplaintRepository complaintRepository;

    public Complaint save(Complaint complaint) {
        return complaintRepository.save(complaint);
    }

    public List<Complaint> getComplaintsByUser(User user) {
        return complaintRepository.findByUserOrderByDateDesc(user);
    }

    public List<Complaint> getAllComplaints() {
        return complaintRepository.findAllByOrderByDateDesc();
    }

    public void updateStatus(int complaintId, String status) {
        complaintRepository.findById(complaintId).ifPresent(c -> {
            c.setStatus(status);
            complaintRepository.save(c);
        });
    }

    public long getTotalCount() {
        return complaintRepository.count();
    }

    public long getPendingCount() {
        return complaintRepository.countByStatus("Pending");
    }
}
