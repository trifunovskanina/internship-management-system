-- 1. Students without assigned internships
SELECT p.first_name, p.last_name
FROM student AS s
JOIN person AS p ON p.id = s.person_id
LEFT JOIN internship_assignment AS ia ON s.id = ia.student_id
WHERE ia.id IS NULL;


-- 2. Number of applications per internship
SELECT i.title,
		COUNT(ia.id) AS application_count
FROM internship AS i
LEFT JOIN internship_application AS ia ON i.id = ia.internship_id
GROUP BY i.id, i.title
ORDER BY application_count DESC;

	
-- 3. Average grade per company
SELECT c.name AS company,
		ROUND(AVG(ie.grade), 2) AS avg_grade
FROM company AS c
JOIN internship AS i ON c.id = i.company_id
JOIN internship_assignment AS ia ON i.id = ia.internship_id
JOIN internship_evaluation AS ie ON ia.id = ie.assignment_id
GROUP BY c.id, c.name;


-- 4. Number of documents per internship assignment
SELECT ia.id AS assignment_id,
		COUNT(d.id) AS document_count
FROM internship_assignment AS ia
LEFT JOIN document AS d ON ia.id = d.assignment_id
GROUP BY ia.id;


-- 5. Internship participation per study program
SELECT sp.name AS study_program,
		COUNT(ia.id) AS internships
FROM study_program AS sp
JOIN student AS s ON sp.id = s.study_program_id
LEFT JOIN internship_assignment AS ia ON s.id = ia.student_id
GROUP BY sp.id, sp.name
ORDER BY internships DESC;


-- 6. Average internship duration per company
SELECT c.name,
	ROUND(AVG(ia.end_date - ia.start_date), 1) AS average_duration_days
FROM company AS c
JOIN internship AS i ON c.id = i.company_id
JOIN internship_assignment AS ia ON i.id = ia.internship_id
GROUP BY c.id, c.name;


-- 7. Internships without applications
SELECT i.*
FROM internship AS i
LEFT JOIN internship_application AS ia ON i.id = ia.internship_id
WHERE ia.id IS NULL;


-- 8. Number of interns per company
SELECT c.name AS company,
		COUNT(ia.id) AS interns
FROM company AS c
JOIN internship AS i ON c.id = i.company_id
LEFT JOIN internship_assignment AS ia ON i.id = ia.internship_id
GROUP BY c.id, c.name
ORDER BY interns DESC;


-- 9. Average student grade per university mentor
SELECT p.first_name, p.last_name,
		ROUND(AVG(ie.grade), 2) AS avg_grade
FROM university_mentor AS um
JOIN mentor AS m ON m.id = um.mentor_id
JOIN person AS p ON p.id = m.person_id
JOIN internship AS i ON um.id = i.university_mentor_id
JOIN internship_assignment AS ia ON i.id = ia.internship_id
JOIN internship_evaluation AS ie ON ia.id = ie.assignment_id
GROUP BY um.id, p.first_name, p.last_name;


-- 10. Internships with more than 3 applications
SELECT i.title,
		COUNT (ia.id) AS application_count
FROM internship AS i
JOIN internship_application AS ia ON i.id = ia.internship_id
GROUP BY i.id, i.title
HAVING COUNT(ia.id) >= 3;


-- 11. Students above average gpa who got internships
SELECT p.first_name, p.last_name, s.gpa
FROM student AS s
JOIN person AS p ON p.id = s.person_id
JOIN internship_assignment AS ia ON s.id = ia.student_id
WHERE s.gpa > (
	SELECT AVG(gpa) FROM student
);


-- 12. Assignments without evaluations
SELECT ia.id AS assignment_id,
		p.first_name, p.last_name,
		i.title
FROM internship_assignment AS ia
JOIN internship AS i ON i.id = ia.internship_id
JOIN student AS s ON ia.student_id = s.id
JOIN person AS p ON p.id = s.person_id
LEFT JOIN internship_evaluation AS ie ON ia.id = ie.assignment_id
WHERE ie.id IS NULL;


-- 13. Total documents submitted per student
SELECT p.first_name, p.last_name,
		COUNT(d.id) AS total_documents
FROM student AS s
JOIN person AS p ON p.id = s.person_id
JOIN internship_assignment AS ia ON s.id = ia.student_id
LEFT JOIN document AS d ON ia.id = d.assignment_id
GROUP BY s.id, p.first_name, p.last_name
ORDER BY total_documents DESC;


-- 14. Best performing internships by average grade
SELECT i.title,
		ROUND(AVG(ie.grade), 2) AS avg_grade
FROM internship AS i
JOIN internship_assignment AS ia ON i.id = ia.internship_id
JOIN internship_evaluation AS ie ON ia.id = ie.assignment_id
GROUP BY i.id, i.title
ORDER BY avg_grade DESC;


-- 15. Full internship completion cycle
SELECT p.first_name, p.last_name,
		i.title, ia.start_date, ia.end_date,
		ie.grade
FROM student AS s
JOIN person AS p ON p.id = s.person_id
JOIN internship_assignment AS ia ON s.id = ia.student_id
JOIN internship AS i ON i.id = ia.internship_id
LEFT JOIN internship_evaluation AS ie ON ia.id = ie.assignment_id;


-- 16. Acceptance rate per internship
WITH accepted AS (
	SELECT internship_id,
			COUNT(*) AS total_applications,
			COUNT(*) FILTER (WHERE status = 'ACCEPTED') AS accepted_applications
	FROM internship_application
	GROUP BY internship_id
)

SELECT i.title, 
		total_applications, 
		accepted_applications,
		ROUND(accepted_applications::DECIMAL / total_applications * 100.0) AS acceptance_rate
FROM accepted AS a
JOIN internship AS i ON i.id = a.internship_id
ORDER BY acceptance_rate DESC;
