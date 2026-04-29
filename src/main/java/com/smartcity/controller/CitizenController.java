package com.smartcity.controller;

import com.smartcity.model.*;
import com.smartcity.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/citizen")
public class CitizenController {

    @Autowired private UserService userService;
    @Autowired private ComplaintService complaintService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private BillService billService;
    @Autowired private AnnouncementService announcementService;

    private User getLoggedUser(HttpSession session) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj instanceof User) return (User) userObj;
        return null;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        
        model.addAttribute("userName", user.getName());
        model.addAttribute("complaintCount", complaintService.getComplaintsByUser(user).size());
        model.addAttribute("appointmentCount", appointmentService.getByUser(user).size());
        model.addAttribute("billCount", billService.getByUser(user).stream().filter(b -> "Unpaid".equals(b.getStatus())).count());
        
        return "citizen/dashboard";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "citizen/profile";
    }

    @GetMapping("/complaints")
    public String complaints(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        model.addAttribute("complaints", complaintService.getComplaintsByUser(user));
        return "citizen/complaints";
    }

    @GetMapping("/new-complaint")
    public String newComplaintPage(HttpSession session) {
        if (getLoggedUser(session) == null) return "redirect:/login";
        return "citizen/new-complaint";
    }

    @PostMapping("/new-complaint")
    public String addComplaint(@ModelAttribute Complaint complaint, HttpServletRequest request, HttpSession session) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        
        String manualPath = request.getParameter("imagePath");
        if (manualPath != null && !manualPath.isEmpty()) {
            complaint.setImagePath(manualPath);
        }
        
        complaint.setUser(user);
        System.out.println(">>> SAVING COMPLAINT. Image Path: '" + complaint.getImagePath() + "'");
        complaintService.save(complaint);
        return "redirect:/citizen/complaints?success=true";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        model.addAttribute("appointments", appointmentService.getByUser(user));
        return "citizen/appointments";
    }

    @GetMapping("/book-appointment")
    public String bookAppointmentPage(HttpSession session) {
        if (getLoggedUser(session) == null) return "redirect:/login";
        return "citizen/book-appointment";
    }

    @PostMapping("/book-appointment")
    public String bookAppointment(@ModelAttribute Appointment appointment, HttpSession session) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        appointment.setUser(user);
        appointmentService.save(appointment);
        return "redirect:/citizen/appointments?success=true";
    }

    @GetMapping("/bills")
    public String bills(HttpSession session, Model model) {
        User user = getLoggedUser(session);
        if (user == null) return "redirect:/login";
        model.addAttribute("bills", billService.getByUser(user));
        return "citizen/bills";
    }

    @PostMapping("/pay-bill")
    public String payBill(@RequestParam int billId, HttpSession session) {
        if (getLoggedUser(session) == null) return "redirect:/login";
        billService.markAsPaid(billId);
        return "redirect:/citizen/bills?paid=true";
    }

    @GetMapping("/announcements")
    public String announcements(HttpSession session, Model model) {
        if (getLoggedUser(session) == null) return "redirect:/login";
        model.addAttribute("announcements", announcementService.getAll());
        return "citizen/announcements";
    }

    @GetMapping("/complaint-map")
    public String complaintMap(HttpSession session) {
        if (getLoggedUser(session) == null) return "redirect:/login";
        return "citizen/complaint-map";
    }
    @PostMapping("/upload-image")
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile file, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        if (file.isEmpty()) {
            response.put("error", "Empty file");
            return response;
        }

        try {
            String uploadBase = "C:/Projects/SmartCityPortal/uploads/complaints/";
            Path rootPath = Paths.get(uploadBase);
            if (!Files.exists(rootPath)) Files.createDirectories(rootPath);

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename().replaceAll("[^a-zA-Z0-9._-]", "_");
            Path destPath = rootPath.resolve(fileName);
            Files.copy(file.getInputStream(), destPath, StandardCopyOption.REPLACE_EXISTING);

            response.put("success", true);
            response.put("path", "uploads/complaints/" + fileName);
        } catch (IOException e) {
            System.out.println(">>> UPLOAD ERROR: " + e.getMessage());
            response.put("error", e.getMessage());
        }
        return response;
    }
    @GetMapping("/map-data")
    @ResponseBody
    public List<Complaint> mapData() {
        return complaintService.getAllComplaints();
    }
}
