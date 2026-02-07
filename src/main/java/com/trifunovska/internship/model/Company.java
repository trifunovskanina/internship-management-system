package com.trifunovska.internship.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "company")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true)
    private String name;

    private String address;

    private String industry;

    @OneToOne(optional = false,  cascade = CascadeType.ALL)
    @JoinColumn(name = "contact_id", nullable = false, unique = true)
    private ContactInformation contactInformation;
}
