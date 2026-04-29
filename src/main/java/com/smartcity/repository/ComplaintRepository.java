package com.smartcity.repository;

import com.smartcity.model.Complaint;
import com.smartcity.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Integer> {
    List<Complaint> findByUserOrderByDateDesc(User user);
    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"user"})
    List<Complaint> findAllByOrderByDateDesc();
    
    long countByStatus(String status);
}
