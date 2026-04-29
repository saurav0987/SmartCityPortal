package com.smartcity.repository;

import com.smartcity.model.Appointment;
import com.smartcity.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Integer> {
    List<Appointment> findByUserOrderByDateDesc(User user);
    List<Appointment> findAllByOrderByDateDesc();
}
