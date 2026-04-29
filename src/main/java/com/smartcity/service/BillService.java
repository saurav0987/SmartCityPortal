package com.smartcity.service;

import com.smartcity.model.Bill;
import com.smartcity.model.User;
import com.smartcity.repository.BillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class BillService {

    @Autowired
    private BillRepository billRepository;

    public Bill save(Bill bill) {
        return billRepository.save(bill);
    }

    public List<Bill> getByUser(User user) {
        return billRepository.findByUserOrderByDueDateAsc(user);
    }

    public List<Bill> getAll() {
        return billRepository.findAllByOrderByDueDateAsc();
    }

    public void markAsPaid(int id) {
        billRepository.findById(id).ifPresent(b -> {
            b.setStatus("Paid");
            billRepository.save(b);
        });
    }

    public long getUnpaidCount() {
        return billRepository.countByStatus("Unpaid");
    }
}
