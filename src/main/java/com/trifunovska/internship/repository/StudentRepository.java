package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT * 
                    FROM student WHERE person_id = :person_id
    """)
    Student findByPersonId(@Param("person_id") Integer personId);
}