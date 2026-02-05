package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.Company;
import com.trifunovska.internship.model.CompanyDepartment;
import com.trifunovska.internship.model.CompanyMentor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CompanyMentorRepository extends JpaRepository<CompanyMentor, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT cm.* 
                    FROM company_mentor AS cm 
                    JOIN mentor AS m ON cm.mentor_id = m.id 
                    WHERE m.person_id = :person_id
    """)
    CompanyMentor findByPersonId(@Param("person_id") Integer personId);

    @Query(nativeQuery = true,
            value = """
                    SELECT cd.* 
                    FROM company_mentor AS cm 
                    JOIN company_department AS cd ON cm.department_id = cd.id 
                    WHERE cm.id = :company_mentor_id
    """)
    CompanyDepartment findDepartment(@Param("company_mentor_id") Integer companyMentorId);

    @Query(nativeQuery = true,
            value = """
                    SELECT COUNT(i.id) 
                    FROM internship AS i 
                    JOIN company_mentor AS cm ON i.company_mentor_id = cm.id 
                    WHERE cm.id = :company_mentor_id
    """)
    Integer countInternships(@Param("company_mentor_id") Integer companyMentorId);

    @Query(nativeQuery = true,
            value = """
                    SELECT c.* 
                    FROM company AS c 
                    JOIN company_department AS cd ON c.id = cd.company_id 
                    JOIN company_mentor AS cm ON cm.department_id = cd.id 
                    WHERE cm.id = :company_mentor_id
    """)
    Company findCompany(@Param("company_mentor_id") Integer companyMentorId);
}
