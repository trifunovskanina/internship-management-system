-- clear for repeated testing
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;


CREATE TABLE person (
    id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE user_account (
    id SERIAL,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    person_id INT NOT NULL UNIQUE,

    CHECK (role IN ('ADMIN', 'UNIVERSITY_MENTOR', 'COMPANY_MENTOR', 'STUDENT')),

    PRIMARY KEY (id),

    FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE contact_information (
    id SERIAL,
    email TEXT NOT NULL,
    phone_number TEXT,
    person_id INT NOT NULL,

    -- one-to-one
    UNIQUE (person_id),

    PRIMARY KEY (id),

    FOREIGN KEY (person_id) REFERENCES person(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE faculty (
    id SERIAL,
    name TEXT NOT NULL UNIQUE,

    PRIMARY KEY (id)
);

CREATE TABLE study_program (
    id SERIAL,
    name TEXT NOT NULL UNIQUE,
    faculty_id INT NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (faculty_id) REFERENCES faculty(id)
);

CREATE TABLE semester (
    id SERIAL,
    name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    CHECK (start_date < end_date),

    PRIMARY KEY (id)
);

CREATE TABLE student (
    id SERIAL,
    person_id INT NOT NULL UNIQUE,
    index_number TEXT NOT NULL UNIQUE,
    gpa REAL,
    study_program_id INT NOT NULL,
    semester_id INT NOT NULL,

    CHECK (gpa BETWEEN 6.0 AND 10.0),

    PRIMARY KEY (id),

    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (study_program_id) REFERENCES study_program(id),
    FOREIGN KEY (semester_id) REFERENCES semester(id)
);

CREATE TABLE mentor (
    id SERIAL,
    person_id INT NOT NULL UNIQUE,

    PRIMARY KEY (id),

    FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE university_mentor (
    id SERIAL,
    mentor_id INT NOT NULL UNIQUE,
    faculty_id INT NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (mentor_id) REFERENCES mentor(id),
    FOREIGN KEY (faculty_id) REFERENCES faculty(id)
);

CREATE TABLE company (
    id SERIAL,
    name TEXT NOT NULL UNIQUE,
    address TEXT,
    industry TEXT,

    PRIMARY KEY (id)
);

CREATE TABLE company_department (
    id SERIAL,
    name TEXT NOT NULL,
    company_id INT NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (company_id) REFERENCES company(id)
);

CREATE TABLE company_location (
    id SERIAL,
    city TEXT NOT NULL,
    country TEXT NOT NULL,
    company_id INT NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (company_id) REFERENCES company(id)
);

CREATE TABLE company_mentor (
    id SERIAL,
    mentor_id INT NOT NULL UNIQUE,
    department_id INT NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (mentor_id) REFERENCES mentor(id),
    FOREIGN KEY (department_id) REFERENCES company_department(id)
);

CREATE TABLE company_collaboration (
    company_id_1 INT NOT NULL,
    company_id_2 INT NOT NULL,

    PRIMARY KEY (company_id_1, company_id_2),

    FOREIGN KEY (company_id_1) REFERENCES company(id),
    FOREIGN KEY (company_id_2) REFERENCES company(id),

    CHECK (company_id_1 < company_id_2)
);

CREATE TABLE skill (
    id SERIAL,
    name TEXT NOT NULL UNIQUE,

    PRIMARY KEY (id)
);

CREATE TABLE student_skill (
    student_id INT NOT NULL,
    skill_id INT NOT NULL,

    PRIMARY KEY (student_id, skill_id),

    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (skill_id) REFERENCES skill(id)
);

CREATE TABLE internship (
    id SERIAL,
    title TEXT NOT NULL,
    description TEXT,
    duration_weeks INT NOT NULL,
    company_id INT NOT NULL,
    company_mentor_id INT NOT NULL,
    university_mentor_id INT NOT NULL,

    CHECK (duration_weeks > 0),

    PRIMARY KEY (id),

    FOREIGN KEY (company_id) REFERENCES company(id),
    FOREIGN KEY (company_mentor_id) REFERENCES company_mentor(id),
    FOREIGN KEY (university_mentor_id) REFERENCES university_mentor(id)
);

CREATE TABLE internship_skill (
    internship_id INT NOT NULL,
    skill_id INT NOT NULL,

    PRIMARY KEY (internship_id, skill_id),

    FOREIGN KEY (internship_id) REFERENCES internship(id),
    FOREIGN KEY (skill_id) REFERENCES skill(id)
);


CREATE TABLE internship_application (
    id SERIAL,
    student_id INT NOT NULL,
    internship_id INT NOT NULL,
    status TEXT NOT NULL,
    application_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
	-- student cannot apply twice
    UNIQUE (student_id, internship_id),

    PRIMARY KEY (id),

    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (internship_id) REFERENCES internship(id)
);

CREATE TABLE application_document (
    id SERIAL,
    application_id INT NOT NULL,
    type TEXT NOT NULL,
    file_path TEXT NOT NULL,
    upload_date DATE NOT NULL DEFAULT CURRENT_DATE,

    PRIMARY KEY (id),

    FOREIGN KEY (application_id) REFERENCES internship_application(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE internship_assignment (
    id SERIAL,
    student_id INT NOT NULL,
    internship_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    semester_id INT NOT NULL,

    CHECK (start_date < end_date),
    UNIQUE (student_id, internship_id),

    PRIMARY KEY (id),

    FOREIGN KEY (semester_id) REFERENCES semester(id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (internship_id) REFERENCES internship(id)
);

CREATE TABLE document (
    id SERIAL,
    assignment_id INT NOT NULL,
    document_type TEXT NOT NULL,
    file_path TEXT NOT NULL,
    upload_date DATE NOT NULL DEFAULT CURRENT_DATE,

    PRIMARY KEY (id),

    FOREIGN KEY (assignment_id) REFERENCES internship_assignment(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE internship_evaluation (
    id SERIAL,
    assignment_id INT NOT NULL UNIQUE,
    grade INT,
    feedback TEXT,
    evaluation_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CHECK (grade BETWEEN 6 AND 10),

    PRIMARY KEY (id),

    FOREIGN KEY (assignment_id) REFERENCES internship_assignment(id)
);
