package com.smartcity.service;

import com.smartcity.model.Appointment;
import com.smartcity.model.User;
import com.smartcity.repository.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    public Appointment save(Appointment appointment) {
        return appointmentRepository.save(appointment);
    }

    public List<Appointment> getByUser(User user) {
        return appointmentRepository.findByUserOrderByDateDesc(user);
    }

    public List<Appointment> getAll() {
        return appointmentRepository.findAllByOrderByDateDesc();
    }

    public void updateStatus(int id, String status) {
        appointmentRepository.findById(id).ifPresent(a -> {
            a.setStatus(status);
            appointmentRepository.save(a);
        });
    }

    public long getTotalCount() {
        return appointmentRepository.count();
    }
}
