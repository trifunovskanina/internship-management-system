package com.trifunovska.internship.service;

import com.trifunovska.internship.model.Company;
import com.trifunovska.internship.model.CompanyDepartment;
import com.trifunovska.internship.model.CompanyMentor;
import com.trifunovska.internship.repository.CompanyMentorRepository;
import org.springframework.stereotype.Service;

@Service
public class CompanyMentorService {
    private final CompanyMentorRepository companyMentorRepository;

    public CompanyMentorService(CompanyMentorRepository companyMentorRepository) {
        this.companyMentorRepository = companyMentorRepository;
    }

    public CompanyMentor findByPersonId(Integer personId) {
        return companyMentorRepository.findByPersonId(personId);
    }

    public CompanyDepartment findDepartment(Integer companyMentorId) {
        return companyMentorRepository.findDepartment(companyMentorId);
    }

    public Integer countInternships(Integer companyMentorId) {
        return companyMentorRepository.countInternships(companyMentorId);
    }

    public Company findCompany(Integer companyMentorId) {
        return companyMentorRepository.findCompany(companyMentorId);
    }
}
