-- View for student internship applications
CREATE VIEW internship_applications AS
SELECT
    p.first_name AS first_name,
    p.last_name AS last_name,
    i.title AS internship_title,
    ia.status AS application_status
FROM student AS s
JOIN person AS p ON p.id = s.person_id
LEFT JOIN internship_application AS ia ON s.id = ia.student_id
LEFT JOIN internship AS i ON i.id = ia.internship_id;
