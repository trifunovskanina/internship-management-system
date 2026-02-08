package com.trifunovska.internship.service;

import com.trifunovska.internship.model.Internship;
import com.trifunovska.internship.model.InternshipApplication;
import com.trifunovska.internship.model.Student;
import com.trifunovska.internship.model.enums.ApplicationStatus;
import com.trifunovska.internship.model.enums.FileType;
import com.trifunovska.internship.repository.InternshipApplicationRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

@Service
public class InternshipApplicationService {
    private final InternshipApplicationRepository internshipApplicationRepository;
    private final ApplicationDocumentService applicationDocumentService;

    public InternshipApplicationService(InternshipApplicationRepository internshipApplicationRepository, ApplicationDocumentService applicationDocumentService) {
        this.internshipApplicationRepository = internshipApplicationRepository;
        this.applicationDocumentService = applicationDocumentService;
    }

    @Transactional
    public void create(Student student, Internship internship, MultipartFile cvFile, MultipartFile motivationFile) {
        if (hasApplied(student.getId(), internship.getId()))
            throw new IllegalArgumentException("Student already has applied for this internship");

        InternshipApplication application = new InternshipApplication();
        application.setStudent(student);
        application.setInternship(internship);
        application.setStatus(ApplicationStatus.PENDING);
        application.setApplicationDate(LocalDate.now());

        internshipApplicationRepository.save(application);

        applicationDocumentService.create(application, cvFile, FileType.CV);
        applicationDocumentService.create(application, motivationFile, FileType.MOTIVATION);

        // TODO: Store files on disk
    }

    public void updateStatus(Integer applicationId, ApplicationStatus status) {
        InternshipApplication application = findById(applicationId);
        application.setStatus(status);
        internshipApplicationRepository.save(application);
    }

    public Boolean hasApplied(Integer studentId, Integer internshipId) {
        return internshipApplicationRepository.existsByStudentIdAndInternshipId(studentId, internshipId);
    }

    public List<InternshipApplication> findAllByStudent(Integer studentId) {
        return internshipApplicationRepository.findAllByStudent(studentId);
    }

    public List<InternshipApplication> findAllByInternshipId(Integer internshipId) {
        return internshipApplicationRepository.findAllByInternshipId(internshipId);
    }

    public InternshipApplication findById(Integer id) {
        return internshipApplicationRepository.findById(id).orElseThrow();
    }
}
