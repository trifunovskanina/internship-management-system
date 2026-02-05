package com.trifunovska.internship.service;

import com.trifunovska.internship.model.CompanyMentor;
import com.trifunovska.internship.model.Internship;
import com.trifunovska.internship.repository.InternshipRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InternshipService {
    private final InternshipRepository internshipRepository;

    public InternshipService(InternshipRepository internshipRepository) {
        this.internshipRepository = internshipRepository;
    }

    public List<Internship> findInternshipsSupervisedByCompanyMentor(Integer companyMentorId) {
        return internshipRepository.findInternshipsSupervisedByCompanyMentor(companyMentorId);
    }

    public Internship findInternshipById(Integer internshipId) {
        return internshipRepository.findById(internshipId).orElseThrow();
    }

    public List<Internship> findAll() {
        return internshipRepository.findAll();
    }

    public Internship findById(Integer internshipId) {
        return internshipRepository.findById(internshipId).orElseThrow();
    }

    public Boolean isMentoredBy(Internship internship, CompanyMentor companyMentor) {
        return internship.getCompanyMentor().getId().equals(companyMentor.getId());
    }
}
