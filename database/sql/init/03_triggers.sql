DROP TRIGGER IF EXISTS tr_accepted_application ON internship_assignment;
DROP TRIGGER IF EXISTS tr_check_evaluation_date ON internship_evaluation;
DROP TRIGGER IF EXISTS tr_active_internships ON internship_assignment;

DROP FUNCTION IF EXISTS accepted_application_check();
DROP FUNCTION IF EXISTS check_evaluation_date();
DROP FUNCTION IF EXISTS active_internships();

-- PREVENT ASSIGNMENT IF APPLICATION NOT ACCEPTED
CREATE OR REPLACE FUNCTION accepted_application_check()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM internship_application
        WHERE student_id = NEW.student_id
          AND internship_id = NEW.internship_id
          AND status = 'ACCEPTED'
    ) THEN
        RAISE EXCEPTION
            'Student % does not have an ACCEPTED application for internship %',
            NEW.student_id, NEW.internship_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_accepted_application
BEFORE INSERT ON internship_assignment
FOR EACH ROW
EXECUTE FUNCTION accepted_application_check();


-- PREVENT EVALUATION BEFORE INTERNSHIP ENDS
CREATE OR REPLACE FUNCTION check_evaluation_date()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM internship_assignment
        WHERE id = NEW.assignment_id
          AND NEW.evaluation_date < end_date
    ) THEN
        RAISE EXCEPTION
            'Internship has not ended yet';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_check_evaluation_date
BEFORE INSERT ON internship_evaluation
FOR EACH ROW
EXECUTE FUNCTION check_evaluation_date();

-- PREVENT MULTIPLE CONCURRENT INTERNSHIPS
CREATE OR REPLACE FUNCTION active_internships()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM internship_assignment AS ia
        WHERE ia.student_id = NEW.student_id
          AND NEW.start_date < ia.end_date
          AND NEW.end_date > ia.start_date
    ) THEN
        RAISE EXCEPTION
            'Student has an active internship';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_active_internships
BEFORE INSERT ON internship_assignment
FOR EACH ROW
EXECUTE FUNCTION active_internships();