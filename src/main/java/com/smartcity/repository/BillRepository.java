package com.smartcity.repository;

import com.smartcity.model.Bill;
import com.smartcity.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BillRepository extends JpaRepository<Bill, Integer> {
    List<Bill> findByUserOrderByDueDateAsc(User user);
    List<Bill> findAllByOrderByDueDateAsc();
    long countByStatus(String status);
}
