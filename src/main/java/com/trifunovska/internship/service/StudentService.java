package com.trifunovska.internship.service;

import com.trifunovska.internship.model.Student;
import com.trifunovska.internship.repository.StudentRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class StudentService {
    private final StudentRepository studentRepository;

    public StudentService(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    public Student findByPersonId(Integer id) {
        return studentRepository.findByPersonId(id);
    }
}
