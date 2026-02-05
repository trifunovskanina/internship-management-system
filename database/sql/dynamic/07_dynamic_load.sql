-- Dynamic data generation for performance analysis

-- Remove all data for rerun
TRUNCATE TABLE
    internship_evaluation,
    document,
    internship_assignment,
    internship_application,
    student_skill,
    student,
    person,
    contact_information
RESTART IDENTITY CASCADE;

-- Inserting 20 001 students
INSERT INTO person (first_name, last_name)
SELECT
    'Name' || gs,
    'Surname' || gs
FROM generate_series(1000, 21000) AS gs;  -- integers 1000 to 21000


INSERT INTO contact_information (email, person_id)
SELECT
    'student' || gs || '@student.edu',
    gs - 999
FROM generate_series(1000, 21000) AS gs;


INSERT INTO student (person_id, index_number, gpa, study_program_id, semester_id)
SELECT
    gs - 999,
    'IDX' || gs,
    ROUND((random() * 4 + 6)::numeric, 2),  -- gpa 6.0 to 10.0
    (floor(random() * 4) + 1)::int,  -- study program 1 to 4
    1
FROM generate_series(1000, 21000) AS gs;


-- Inserting 80 000 applications
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

-- Inserting 5000 assignments
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

-- Inserting evaluations
INSERT INTO internship_evaluation (assignment_id, grade, feedback, evaluation_date)
SELECT
    id,
    (random() * 4 + 6)::int,  -- grade 6 to 10
    'Auto-generated evaluation',
    DATE '2024-09-15'
FROM internship_assignment
WHERE random() < 0.7;

-- Inserting 5 documents per assignment
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