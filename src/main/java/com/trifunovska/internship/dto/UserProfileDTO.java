package com.trifunovska.internship.dto;

import lombok.Data;

@Data
public class UserProfileDTO {
    private String firstName;
    private String lastName;
    private String email;
    private String role;
    private Boolean enabled;

    private String indexNumber;
    private Double gpa;
    private String studyProgram;
    private String faculty;

    private String company;
    private String department;
    private Integer owningInternships;
}
