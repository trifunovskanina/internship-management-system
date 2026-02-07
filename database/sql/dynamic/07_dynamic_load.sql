-- Remove all data for rerun
TRUNCATE TABLE
    internship_evaluation,
    document,
    internship_assignment,
    internship_application,
    student_skill,
    student,
    person,
    contact_information,
	study_program
RESTART IDENTITY CASCADE;


INSERT INTO contact_information (email)
VALUES ('fcse@uni.edu');

INSERT INTO faculty (name, contact_id)
VALUES ('Faculty of Computer Science and Engineering', 1);

INSERT INTO study_program (name, faculty_id) VALUES
('Computer Science', 1),
('Software Engineering and Information Systems', 1),
('Internet Networks and Security', 1),
('Applied Information Technologies', 1);

INSERT INTO semester (name, start_date, end_date)
VALUES ('Summer 2024', '2024-06-01', '2024-09-15');


INSERT INTO contact_information (email)
SELECT 'student' || gs || '@student.edu'
FROM generate_series(1, 20000) gs;


INSERT INTO person (first_name, last_name, contact_id)
SELECT
    'Name' || gs,
    'Surname' || gs,
    gs + 1
FROM generate_series(1, 20000) AS gs;  -- integers 1 to 20000


INSERT INTO student (person_id, index_number, gpa, study_program_id, semester_id)
SELECT
    gs,
    'IDX' || gs,
    ROUND((random() * 4 + 6)::numeric, 2),  -- gpa 6.0 to 10.0
    (floor(random() * 4) + 1)::int,  -- study program 1 to 4
    1
FROM generate_series(1, 20000) AS gs;


INSERT INTO internship_application (student_id, internship_id, status)
SELECT DISTINCT ON (s.id, i.id)
    s.id,
    i.id,
    CASE
        WHEN random() < 0.6 THEN 'PENDING'
        WHEN random() < 0.85 THEN 'ACCEPTED'
        ELSE 'REJECTED'
    END
FROM student s
CROSS JOIN internship i
ORDER BY s.id, i.id, random()
LIMIT 80000;


INSERT INTO internship_assignment (student_id, internship_id, start_date, end_date, semester_id)
SELECT DISTINCT ON (ia.student_id, ia.internship_id)
    ia.student_id,
    ia.internship_id,
    DATE '2024-06-01' + (random() * 10)::int,
    DATE '2024-08-01' + (random() * 30)::int,
    1
FROM internship_application ia
WHERE ia.status = 'ACCEPTED'
ORDER BY ia.student_id, ia.internship_id
LIMIT 5000;


INSERT INTO internship_evaluation (assignment_id, grade, feedback, evaluation_date)
SELECT
    id,
    (random() * 4 + 6)::int,  -- grade 6 to 10
    'Auto-generated evaluation',
    DATE '2024-09-15'
FROM internship_assignment
WHERE random() < 0.7;


INSERT INTO document (assignment_id, document_type, file_path)
SELECT ia.id,
    CASE
        WHEN random() < 0.5 
		THEN 'REPORT'
        ELSE 'LOGBOOK'
    END,
    '/docs/generated_doc_' || gs || '.pdf'
FROM internship_assignment ia,
     generate_series(1, 5) gs;
