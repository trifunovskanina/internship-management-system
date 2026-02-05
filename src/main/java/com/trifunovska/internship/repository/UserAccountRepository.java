package com.trifunovska.internship.repository;

import com.trifunovska.internship.model.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface UserAccountRepository extends JpaRepository<UserAccount, Integer> {

    @Query(nativeQuery = true,
            value = """
                    SELECT *
                    FROM user_account
                    WHERE username = :username
    """)
    Optional<UserAccount> findByUsername(String username);
}
