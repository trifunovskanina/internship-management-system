package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.ApplicationDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationDocumentRepository extends JpaRepository<ApplicationDocument, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT ad.*
                    FROM application_document 
		            WHERE application_id = :application_id
    """)
    List<ApplicationDocument> findByApplicationId(@Param("application_id") Integer applicationId);

}
