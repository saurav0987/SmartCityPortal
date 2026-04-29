package com.smartcity.service;

import com.smartcity.model.User;
import com.smartcity.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public boolean register(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            return false;
        }
        userRepository.save(user);
        return true;
    }

    public Optional<User> login(String email, String password) {
        return userRepository.findByEmailAndPassword(email, password);
    }

    public boolean emailExists(String email) {
        return userRepository.findByEmail(email).isPresent();
    }

    public List<User> getAllCitizens() {
        return userRepository.findByRole("CITIZEN");
    }

    public long getTotalCitizens() {
        return userRepository.countByRole("CITIZEN");
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }
}
