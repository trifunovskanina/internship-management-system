package com.trifunovska.internship.web;

import com.trifunovska.internship.model.*;
import com.trifunovska.internship.model.enums.ApplicationStatus;
import com.trifunovska.internship.service.*;
import jakarta.transaction.Transactional;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import java.util.List;

@Controller
@RequestMapping("/company-mentor")
@PreAuthorize("hasRole('COMPANY_MENTOR')")
public class CompanyMentorController {
    private final InternshipService internshipService;
    private final UserAccountService userAccountService;
    private final CompanyMentorService companyMentorService;
    private final InternshipApplicationService internshipApplicationService;
    private final ApplicationDocumentService applicationDocumentService;

    public CompanyMentorController(InternshipService internshipService, UserAccountService userAccountService, CompanyMentorService companyMentorService, InternshipApplicationService internshipApplicationService, ApplicationDocumentService applicationDocumentService) {
        this.internshipService = internshipService;
        this.userAccountService = userAccountService;
        this.companyMentorService = companyMentorService;
        this.internshipApplicationService = internshipApplicationService;
        this.applicationDocumentService = applicationDocumentService;
    }

    private CompanyMentor getCurrentMentor(Authentication authentication) {
        String username = authentication.getName();
        UserAccount account = userAccountService.findByUsername(username);
        CompanyMentor companyMentor = companyMentorService.findByPersonId(account.getPerson().getId());

        if (companyMentor == null)
            throw new IllegalStateException("Company mentor profile is missing");

        return companyMentor;
    }

    @ExceptionHandler(IllegalStateException.class)
    public String missingProfile() {
        return "redirect:/profile/incomplete";
    }

    @GetMapping("/internships")
    public String getInternshipsPage(Model model,
                                     Authentication authentication) {

        model.addAttribute("internships", internshipService.findAll());

        CompanyMentor companyMentor = getCurrentMentor(authentication);

        List<Internship> internships = internshipService
                .findInternshipsSupervisedByCompanyMentor(companyMentor.getId());

        List<Integer> ownedIds = internships.stream().map(Internship::getId).toList();
        model.addAttribute("ownedIds", ownedIds);

        return "internships";
    }

    @GetMapping("/supervise")
    public String getSupervisedInternships(Authentication authentication,
                                           Model model) {

        CompanyMentor companyMentor = getCurrentMentor(authentication);

        List<Internship> internships = internshipService
                .findInternshipsSupervisedByCompanyMentor(companyMentor.getId());

        List<Integer> ownedIds = internships.stream().map(Internship::getId).toList();

        model.addAttribute("internships", internships);
        model.addAttribute("ownedIds", ownedIds);

        return "internships";
    }

    @GetMapping("/internships/{id}/applications")
    public String viewApplicationReadOnly(@PathVariable Integer id,
                                          Authentication authentication,
                                          Model model) {

        CompanyMentor companyMentor = getCurrentMentor(authentication);

        Internship internship = internshipService.findById(id);

        List<InternshipApplication> applications = internshipApplicationService
                .findAllByInternshipId(internship.getId());

        boolean isOwner = internshipService.isMentoredBy(internship, companyMentor);

        model.addAttribute("applications", applications);
        model.addAttribute("internship", internship);
        model.addAttribute("isOwner", isOwner);

        return "internship-applications";
    }

    @Transactional
    @GetMapping("/supervise/edit/{id}")
    public String editApplication(@PathVariable Integer id,
                                  Authentication authentication,
                                  Model model) {

        CompanyMentor companyMentor = getCurrentMentor(authentication);

        InternshipApplication application = internshipApplicationService.findById(id);

        if (!internshipService.isMentoredBy(application.getInternship(), companyMentor))
            throw new AccessDeniedException("You are not allowed to edit this application");

        Person person = application.getStudent().getPerson();

        Internship internship = internshipService
                .findById(application.getInternship().getId());

        StudyProgram program = application.getStudent().getStudyProgram();

        List<ApplicationDocument> documents = applicationDocumentService
                .findByApplicationId(application.getId());
        
        model.addAttribute("application", application);
        model.addAttribute("internship", internship);
        model.addAttribute("statuses", ApplicationStatus.values());
        model.addAttribute("person", person);
        model.addAttribute("program", program);
        model.addAttribute("documents", documents);

        return "application-edit-form";
    }

    @Transactional
    @PostMapping("/supervise/edit")
    public String updateApplication(@RequestParam Integer id,
                                    @RequestParam String status,
                                    Authentication authentication,
                                    Model model) {

        CompanyMentor companyMentor = getCurrentMentor(authentication);

        InternshipApplication application = internshipApplicationService.findById(id);

        if (!internshipService.isMentoredBy(application.getInternship(), companyMentor))
            throw new AccessDeniedException("You are not allowed to edit this application");

        internshipApplicationService.updateStatus(id, ApplicationStatus.valueOf(status));

        Integer internshipId = application.getInternship().getId();

        return "redirect:/company-mentor/internships/" + internshipId + "/applications";
    }
}
