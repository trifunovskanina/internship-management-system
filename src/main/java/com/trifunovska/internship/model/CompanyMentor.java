package com.trifunovska.internship.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "company_mentor")
public class CompanyMentor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne(optional = false)
    @JoinColumn(name = "mentor_id", nullable = false, unique = true)
    private Mentor mentor;

    @ManyToOne(optional = false)
    @JoinColumn(name = "department_id", nullable = false)
    private CompanyDepartment department;
}
