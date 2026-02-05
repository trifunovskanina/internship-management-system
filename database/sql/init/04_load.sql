-- clear data for testing
TRUNCATE TABLE
    internship_evaluation,
    document,
    internship_assignment,
    application_document,
    internship_application,
    internship_skill,
    internship,
    student_skill,
    student,
    company_mentor,
    company_department,
    company_location,
    university_mentor,
    mentor,
    contact_information,
    person,
    skill,
    semester,
    study_program,
    faculty,
    company,
    user_account
RESTART IDENTITY CASCADE;

INSERT INTO faculty (name) VALUES
('Faculty of Computer Science and Engineering');

INSERT INTO study_program (name, faculty_id) VALUES
('Computer Science', 1),
('Software Engineering and Information Systems', 1),
('Internet Networks and Security', 1),
('Applied Information Technologies', 1);

INSERT INTO semester (name, start_date, end_date) VALUES
('Summer 2024', '2024-06-01', '2024-09-15');

INSERT INTO person (first_name, last_name) VALUES
('Nina', 'Trifunovska'),
('Marko', 'Stojanov'),
('Elena', 'Ristova'),
('Ivan', 'Trajkovski'),
('Ivan', 'Kostov'),
('Elena', 'Dimitrova'),
('Stefan', 'Popov'),
('Marija', 'Ilieva'),
('Petar', 'Nikolov'),
('Jovana', 'Angelova'),
('Petar', 'Iliev'),  -- 11
('Marija', 'Nikolova'),
('Stefan', 'Trajkov'),
('Ana', 'Kolevska'),
('Filip', 'Petkov'),
('Ivana', 'Mitrevska'),
('Bojan', 'Spasov'),
('Elena', 'Georgieva'),
('Martin', 'Dimitrov'),
('Sara', 'Naceva'),
('Nikola', 'Stankov'),
('Teodora', 'Velkova');


INSERT INTO user_account (username, password_hash, role, person_id) VALUES
('admin', '$2a$10$bVOe4n0us0WnU7/Wddce8OP2BbxnSeZvVTXLglgPh1SVOj5byzODq', 'ADMIN', 1),
('mentor', '$2a$10$mrUTaBziSTwRZY19dYkvjeT4bEyHbfQ/MoXoWvJCPCcIcl1TAGKwq', 'COMPANY_MENTOR', 5),
('student', '$2a$10$EIvmf2U.EJhg/.Ucz1hA4.E/BfJHgBdooo3seLoHzrG.nPQ/moHii', 'STUDENT', 11);

-- student: $2a$10$EIvmf2U.EJhg/.Ucz1hA4.E/BfJHgBdooo3seLoHzrG.nPQ/moHii
-- mentor: $2a$10$mrUTaBziSTwRZY19dYkvjeT4bEyHbfQ/MoXoWvJCPCcIcl1TAGKwq
-- admin: $2a$10$bVOe4n0us0WnU7/Wddce8OP2BbxnSeZvVTXLglgPh1SVOj5byzODq


INSERT INTO contact_information (email, person_id) VALUES
('nina.trifunovska@uni.edu', 1),
('marko.stojanov@uni.edu', 2),
('elena.ristova@uni.edu', 3),
('ivan.trajkovski@uni.edu', 4),
('ivan.kostov@techsoft.com', 5),
('elena.dimitrova@datacorp.com', 6),
('stefan.popov@cloudnine.com', 7),
('marija.ilieva@cloudnine.com', 8),
('petar.nikolov@secureit.com', 9),
('jovana.angelova@secureit.com', 10),
('petar.iliev@student.edu', 11),
('marija.nikolova@student.edu', 12),
('stefan.trajkov@student.edu', 13),
('ana.kolevska@student.edu', 14),
('filip.petkov@student.edu', 15),
('ivana.mitrevska@student.edu', 16),
('bojan.spasov@student.edu', 17),
('elena.georgieva@student.edu', 18),
('martin.dimitrov@student.edu', 19),
('sara.naceva@student.edu', 20),
('nikola.stankov@student.edu', 21),
('teodora.velkova@student.edu', 22);

INSERT INTO student (person_id, index_number, gpa, study_program_id, semester_id) VALUES
(11, '201001', 8.5, 1, 1),
(12, '201002', 9.2, 2, 1),
(13, '201003', 7.9, 1, 1),
(14, '201004', 9.0, 3, 1),
(15, '201005', 8.1, 2, 1),
(16, '201006', 8.7, 1, 1),
(17, '201007', 7.4, 3, 1),
(18, '201008', 9.5, 2, 1),
(19, '201009', 8.0, 1, 1),
(20, '201010', 9.1, 3, 1),
(21, '201011', 7.8, 2, 1),
(22, '201012', 8.9, 1, 1);

INSERT INTO mentor (person_id) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO university_mentor (mentor_id, faculty_id) VALUES
(1,1),(2,1),(3,1),(4,1);

INSERT INTO company (name, address, industry) VALUES
('TechSoft', 'Skopje', 'Software'),
('DataCorp', 'Bitola', 'Data Analytics'),
('CloudNine', 'Ohrid', 'Cloud Services'),
('SecureIT', 'Skopje', 'Cybersecurity');

INSERT INTO company_department (name, company_id) VALUES
('Backend', 1),
('Analytics', 2),
('Cloud', 3),
('Security', 4);

INSERT INTO company_mentor (mentor_id, department_id) VALUES
(5, 1),
(6, 2),
(7, 3),
(8, 3),
(9, 4),
(10, 4);

INSERT INTO internship (title, description, duration_weeks, company_id, company_mentor_id, university_mentor_id) VALUES
('Backend Developer Intern', 'Spring & PostgreSQL backend development', 12, 1, 1, 1),
('Data Analyst Intern', 'SQL, reporting, and dashboards', 10, 2, 2, 2),
('Cloud Engineer Intern', 'AWS and cloud infrastructure', 12, 3, 3, 3),
('Frontend Developer Intern', 'React and UI development', 8, 3, 4, 1),
('Cybersecurity Intern', 'Security audits and monitoring', 10, 4, 5, 4),
('Penetration Testing Intern', 'Ethical hacking basics', 12, 4, 6, 4);

INSERT INTO internship_application (student_id, internship_id, status) VALUES
(1, 1, 'PENDING'),
(2, 1, 'ACCEPTED'),
(3, 1, 'REJECTED'),
(4, 2, 'ACCEPTED'),
(5, 2, 'PENDING'),
(6, 3, 'ACCEPTED'),
(7, 3, 'REJECTED'),
(8, 4, 'ACCEPTED'),
(9, 4, 'PENDING'),
(10, 5, 'ACCEPTED'),
(11, 5, 'REJECTED'),
(12, 6, 'ACCEPTED');

INSERT INTO skill (name) VALUES
('SQL'), ('Java'), ('Spring'), ('React'), ('Machine Learning');

INSERT INTO student_skill (student_id, skill_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(4, 5);

INSERT INTO internship_skill (internship_id, skill_id) VALUES
(1, 1),
(1, 2),
(5, 5);

INSERT INTO internship_assignment (student_id, internship_id, start_date, end_date, semester_id) VALUES
(2, 1, '2024-06-01', '2024-08-24', 1),
(4, 2, '2024-06-05', '2024-08-10', 1),
(6, 3, '2024-06-10', '2024-09-01', 1),
(8, 4, '2024-06-03', '2024-07-29', 1),
(10, 5, '2024-06-15', '2024-08-25', 1),
(12, 6, '2024-06-20', '2024-09-10', 1);

INSERT INTO internship_evaluation (assignment_id, grade, feedback) VALUES
(1, 9, 'Excellent backend skills and teamwork.'),
(2, 8, 'Strong analytical thinking and SQL knowledge.'),
(3, 9, 'Very good understanding of cloud concepts.'),
(4, 8, 'Clean UI work and good collaboration.'),
(5, 9, 'High awareness of security practices.'),
(6, 8, 'Solid penetration testing fundamentals.');

INSERT INTO document (assignment_id, document_type, file_path) VALUES
(1, 'REPORT', '/docs/backend_report_1.pdf'),
(1, 'LOGBOOK', '/docs/backend_logbook_1.pdf'),
(2, 'REPORT', '/docs/data_report_2.pdf'),
(2, 'LOGBOOK', '/docs/data_logbook_2.pdf'),
(3, 'REPORT', '/docs/cloud_report_3.pdf'),
(3, 'LOGBOOK', '/docs/cloud_logbook_3.pdf'),
(4, 'REPORT', '/docs/frontend_report_4.pdf'),
(5, 'REPORT', '/docs/security_report_5.pdf'),
(6, 'REPORT', '/docs/pentest_report_6.pdf'),
(6, 'LOGBOOK', '/docs/pentest_logbook_6.pdf');