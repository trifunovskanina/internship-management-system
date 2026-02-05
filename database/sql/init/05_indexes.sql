-- Secondary indexes used to optimize JOIN operations and WHERE clauses
-- They prevent full table scans for frequent queries and reports

DROP INDEX IF EXISTS idx_student_study_program;

DROP INDEX IF EXISTS idx_application_student;
DROP INDEX IF EXISTS idx_application_internship;
DROP INDEX IF EXISTS idx_application_internship_status;
DROP INDEX IF EXISTS idx_application_student_status;

DROP INDEX IF EXISTS idx_internship_university_mentor;

DROP INDEX IF EXISTS idx_assignment_start_date;
DROP INDEX IF EXISTS idx_assignment_student;
DROP INDEX IF EXISTS idx_assignment_internship;

DROP INDEX IF EXISTS idx_internship_company;

-- Use case: List all students enrolled in a specific study program
CREATE INDEX idx_student_study_program
    ON student(study_program_id);

-- Use case: List all applications submitted by a given student
CREATE INDEX idx_application_student
    ON internship_application(student_id);

-- Use case: List all applicants for a specific internship
CREATE INDEX idx_application_internship
    ON internship_application(internship_id);

-- Use case: List applications by given status
CREATE INDEX idx_application_internship_status
	ON internship_application(internship_id, status);

-- Use case: List accepted applications for a given student
CREATE INDEX idx_application_student_status
	ON internship_application(student_id, status);

-- Use case: List internships for a given university mentor
CREATE INDEX idx_internship_university_mentor
	ON internship(university_mentor_id);

-- Use case: List assignments for a given date
CREATE INDEX idx_assignment_start_date
	ON internship_assignment(start_date);

-- Use case: List which internship a student is assigned to
CREATE INDEX idx_assignment_student
    ON internship_assignment(student_id);

-- Use case: List all students assigned to a specific internship
CREATE INDEX idx_assignment_internship
    ON internship_assignment(internship_id);

-- Use case: Generate internship reports grouped by company
CREATE INDEX idx_internship_company
    ON internship(company_id);