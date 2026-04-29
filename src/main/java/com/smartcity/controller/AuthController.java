package com.smartcity.controller;

import com.smartcity.model.User;
import com.smartcity.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "registered", required = false) String registered, Model model) {
        if (registered != null) {
            model.addAttribute("success", "Registration successful! Please login.");
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession session, Model model) {
        Optional<User> user = userService.login(email.trim(), password.trim());
        if (user.isPresent()) {
            User u = user.get();
            session.setAttribute("loggedUser", u);
            session.setAttribute("userId", u.getId());
            session.setAttribute("userRole", u.getRole());
            session.setAttribute("userName", u.getName());

            if ("ADMIN".equals(u.getRole())) {
                return "redirect:/admin?action=dashboard";
            } else {
                return "redirect:/citizen/dashboard";
            }
        } else {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        if (userService.emailExists(user.getEmail())) {
            model.addAttribute("error", "Email already exists.");
            return "register";
        }
        boolean success = userService.register(user);
        if (success) {
            return "redirect:/login?registered=true";
        } else {
            model.addAttribute("error", "Registration failed. Try again.");
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
