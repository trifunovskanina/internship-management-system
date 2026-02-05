package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.Internship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InternshipRepository extends JpaRepository<Internship, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT * 
                    FROM internship 
                    WHERE company_mentor_id = :company_mentor_id
    """)
    List<Internship> findInternshipsSupervisedByCompanyMentor(@Param("company_mentor_id") Integer companyMentorId);
}
