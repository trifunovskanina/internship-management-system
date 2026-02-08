package com.trifunovska.internship.service;

import com.trifunovska.internship.dto.UserProfileDTO;
import com.trifunovska.internship.model.*;
import com.trifunovska.internship.model.enums.Role;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserProfileService {

    private final StudentService studentService;
    private final CompanyMentorService companyMentorService;

    public UserProfileService(StudentService studentService, CompanyMentorService companyMentorService) {
        this.studentService = studentService;
        this.companyMentorService = companyMentorService;
    }

    public UserProfileDTO buildProfile(UserAccount account) {
        UserProfileDTO dto = new UserProfileDTO();

        Person person = account.getPerson();

        dto.setFirstName(person.getFirstName());
        dto.setLastName(person.getLastName());
        dto.setEnabled(account.getEnabled());

        dto.setEmail(person.getContactInformation().getEmail());
        dto.setRole(String.valueOf(account.getRole()));

        if (account.getRole().equals(Role.STUDENT)) {
            Student student = studentService.findByPersonId(person.getId());
            if (student != null) {
                dto.setIndexNumber(student.getIndexNumber());
                dto.setGpa(student.getGpa());
                dto.setStudyProgram(student.getStudyProgram().getName());
                dto.setFaculty(student.getStudyProgram().getFaculty().getName());
            }
        }

        if (account.getRole().equals(Role.COMPANY_MENTOR)) {
            CompanyMentor companyMentor = companyMentorService.findByPersonId(person.getId());
            if (companyMentor != null) {
                dto.setCompany(companyMentorService.findCompany(companyMentor.getId()).getName());
                dto.setDepartment(companyMentorService.findDepartment(companyMentor.getId()).getName());
                dto.setOwningInternships(companyMentorService.countInternships(companyMentor.getId()));
            }
        }

        return dto;
    }
}
