package com.smartcity.controller;

import com.smartcity.model.*;
import com.smartcity.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService userService;
    @Autowired private ComplaintService complaintService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private BillService billService;
    @Autowired private AnnouncementService announcementService;

    private boolean isAdmin(HttpSession session) {
        return "ADMIN".equals(session.getAttribute("userRole"));
    }

    @GetMapping
    public String adminHome(@RequestParam(value = "action", defaultValue = "dashboard") String action, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        if ("dashboard".equals(action)) {
            model.addAttribute("totalUsers", userService.getTotalCitizens());
            model.addAttribute("totalComplaints", complaintService.getTotalCount());
            model.addAttribute("pendingComplaints", complaintService.getPendingCount());
            model.addAttribute("totalAppointments", appointmentService.getTotalCount());
            model.addAttribute("unpaidBills", billService.getUnpaidCount());
            model.addAttribute("totalAnnouncements", announcementService.getTotalCount());
            model.addAttribute("recentComplaints", complaintService.getAllComplaints());
            return "admin/dashboard";
        } else if ("users".equals(action)) {
            model.addAttribute("users", userService.getAllCitizens());
            return "admin/users";
        }
        return "admin/dashboard";
    }

    @GetMapping("/complaints")
    public String complaints(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("complaints", complaintService.getAllComplaints());
        return "admin/complaints";
    }

    @PostMapping("/update-complaint")
    public String updateComplaint(@RequestParam int complaintId, @RequestParam String status, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        complaintService.updateStatus(complaintId, status);
        return "redirect:/admin/complaints";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("appointments", appointmentService.getAll());
        return "admin/appointments";
    }

    @PostMapping("/update-appointment")
    public String updateAppointment(@RequestParam int appointmentId, @RequestParam String status, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        appointmentService.updateStatus(appointmentId, status);
        return "redirect:/admin/appointments";
    }

    @GetMapping("/bills")
    public String bills(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("bills", billService.getAll());
        model.addAttribute("citizens", userService.getAllCitizens());
        return "admin/bills";
    }

    @PostMapping("/add-bill")
    public String addBill(@ModelAttribute Bill bill, org.springframework.validation.BindingResult result, @RequestParam int userId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        
        if (result.hasErrors()) {
            System.out.println(">>> BILL BINDING ERRORS: " + result.getAllErrors());
            return "redirect:/admin/bills?error=invalid_data";
        }

        User user = userService.getUserById(userId);
        if (user != null) {
            bill.setUser(user);
            billService.save(bill);
            return "redirect:/admin/bills?success=true";
        } else {
            return "redirect:/admin/bills?error=user_not_found";
        }
    }

    @GetMapping("/announcements")
    public String announcements(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("announcements", announcementService.getAll());
        return "admin/announcements";
    }

    @PostMapping("/add-announcement")
    public String addAnnouncement(@ModelAttribute Announcement announcement, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        User user = (User) session.getAttribute("loggedUser");
        announcement.setPostedBy(user);
        announcementService.save(announcement);
        return "redirect:/admin/announcements?success=true";
    }

    @PostMapping("/delete-announcement")
    public String deleteAnnouncement(@RequestParam int id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        announcementService.delete(id);
        return "redirect:/admin/announcements";
    }

    @GetMapping("/complaint-map")
    public String complaintMap(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        return "admin/complaint-map";
    }
}
