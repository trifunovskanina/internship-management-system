package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.InternshipApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InternshipApplicationRepository extends JpaRepository<InternshipApplication, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT COUNT(*) > 0 
                    FROM internship_application 
                    WHERE student_id = :student_id AND internship_id = :internship_id
    """)
    Boolean existsByStudentIdAndInternshipId(@Param("student_id") Integer studentId, @Param("internship_id") Integer internshipId);


    @Query(nativeQuery = true,
            value = """
                    SELECT * 
                    FROM internship_application 
                    WHERE student_id = :student_id 
                    ORDER BY application_date DESC
    """)
    List<InternshipApplication> findAllByStudent(@Param("student_id") Integer studentId);


    @Query(nativeQuery = true,
            value = """
                    SELECT * 
                    FROM internship_application 
                    WHERE internship_id = :internship_id 
                    ORDER BY application_date DESC
    """)
    List<InternshipApplication> findAllByInternshipId(@Param("internship_id") Integer internshipId);

    @Query(nativeQuery = true,
            value = """
                    SELECT * 
                    FROM internship_application 
                    WHERE id = :id
    """)
    Optional<InternshipApplication> findById(Integer id);
}
