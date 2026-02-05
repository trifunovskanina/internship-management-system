package com.trifunovska.internship;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class InternshipManagementSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(InternshipManagementSystemApplication.class, args);

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("student: " + encoder.encode("student"));
        System.out.println("mentor: " + encoder.encode("mentor"));
        System.out.println("admin: " + encoder.encode("admin"));
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }
}
