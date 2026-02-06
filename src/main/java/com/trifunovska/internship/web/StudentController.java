package com.trifunovska.internship.web;

import com.trifunovska.internship.model.*;
import com.trifunovska.internship.service.*;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequestMapping("/student")
@PreAuthorize("hasRole('STUDENT')")
public class StudentController {
    private final StudentService studentService;
    private final InternshipApplicationService internshipApplicationService;
    private final InternshipService internshipService;
    private final UserAccountService userAccountService;

    public StudentController(StudentService studentService, InternshipApplicationService internshipApplicationService, InternshipService internshipService, UserAccountService userAccountService) {
        this.studentService = studentService;
        this.internshipApplicationService = internshipApplicationService;
        this.internshipService = internshipService;
        this.userAccountService = userAccountService;
    }

    private Student getCurrentStudent(Authentication authentication) {
        String username = authentication.getName();
        UserAccount account = userAccountService.findByUsername(username);

        Student student = studentService.findByPersonId(account.getPerson().getId());
        if (student == null)
            throw new IllegalStateException("Student profile missing");

        return student;
    }

    @ExceptionHandler(IllegalStateException.class)
    public String missingProfile() {
        return "redirect:/profile/incomplete";
    }

    @GetMapping("/internships")
    public String getInternshipsPage(Model model) {
        model.addAttribute("internships", internshipService.findAll());
        return "internships";
    }

    @GetMapping("/internships/{id}")
    public String applyForInternship(@PathVariable Integer id,
                                     Authentication authentication,
                                     Model model) {

        Student student = getCurrentStudent(authentication);
        if (internshipApplicationService.hasApplied(student.getId(), id))
            return "redirect:/student/internships";

        Internship internship = internshipService.findById(id);
        model.addAttribute("internship", internship);

        return "internship-form";
    }

    @PostMapping("/internships/{id}")
    public String saveInternship(
            @PathVariable Integer id,
            @RequestParam("cvFile") MultipartFile cvFile,
            @RequestParam("motivationFile") MultipartFile motivationFile,
            Authentication authentication,
            Model model) {

        Student student = getCurrentStudent(authentication);
        Internship internship = internshipService.findById(id);
        internshipApplicationService.create(student, internship, cvFile, motivationFile);

        return "redirect:/student/applications";
    }

    @GetMapping("/applications")
    public String viewApplications(Authentication authentication,
                                   Model model) {

        Student student = getCurrentStudent(authentication);
        List<InternshipApplication> applications = internshipApplicationService
                .findAllByStudent(student.getId());

        model.addAttribute("applications", applications);
        return "applications";
    }
}
