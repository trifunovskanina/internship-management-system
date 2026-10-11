# Internship Management System

A system for managing internships, student applications, and role-based workflows in an academic–industry environment.

The system is built using Spring Boot, Spring Security, Thymeleaf, and PostgreSQL with strict role-based access control (RBAC).

---

## Technology Stack

[![Java](https://img.shields.io/badge/Java-ED8B00?logo=openjdk&logoColor=white)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Spring Security](https://img.shields.io/badge/Spring%20Security-6DB33F?logo=springsecurity&logoColor=white)](https://spring.io/projects/spring-security)
[![Thymeleaf](https://img.shields.io/badge/Thymeleaf-005F0F?logo=thymeleaf&logoColor=white)](https://www.thymeleaf.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

---

## Architecture Overview

The underlying database schema is designed and maintained separately in the [internship-management-database](https://github.com/trifunovskanina/internship-management-database) repository.

The application validates the schema at startup and enforces business rules and access control on top of it.

---

## Project Structure

```text
internship-management-system/
│
├── src/
│   ├── main/
│   │   ├── java/com/trifunovska/internship/
│   │   │   ├── config/             
│   │   │   ├── dto/                 
│   │   │   ├── model/   
│   │   │   │   └── enums/
│   │   │   ├── repository/       
│   │   │   ├── service/             
│   │   │   └── web/                
│   │   │
│   │   └── resources/
│   │       ├── static/
│   │       │   ├── css/               
│   │       │   └── js/
│   │       ├── templates/            
│   │       │   └── fragments/        
│   │       └── application.properties
│   │
│   └── test/                       
│
├── database/
│   ├── diagrams/                   
│   └── sql/
│       ├── init/                     
│       ├── dynamic/                 
│       └── reports/                  
│
├── Dockerfile                        
├── docker-compose.yml              
├── pom.xml                           
├── mvnw                            
├── mvnw.cmd
├── .gitignore
└── README.md
```

---

## Security Model

Authentication and authorization are handled using Spring Security with a custom UserDetailsService.

The system enforces Role-Based Access Control (RBAC) at the controller and service layers.  

Authorization is always enforced server-side and is never inferred from UI navigation alone.

---

## Supported Roles

| Role | Description |
|-----|------------|
| Student | View available internships, apply for internships, submit required documents, and track application statuses |
| Company Mentor | View internships they mentor, review student applications, and update application statuses |
| Admin | Manage users, assign roles, activate/deactivate accounts, and view user profiles via DTOs |

---

## Core Features

- Internship listing and application submission
- Document upload and persistence
- Application review and status management
- Role-based dashboards and workflows
- Admin user and role management
- DTO-based profile views
- Strong database integrity enforcement
- Fully containerized runtime environment

---

## Student Dashboard

Students can browse internships and apply for each by attaching required documents. They cannot apply to the same internship twice.

<img src="screenshots/student-dashboard.png" width="600"/>

---

## Company Mentor Dashboard

Company mentors can review student applications and update their statuses only for internships they are **currently mentoring**. After clicking `Edit`, they can view the attached documents before changing an application's status.

<img src="screenshots/mentor-dashboard.png" width="600"/>

---

## Administration Dashboard

Administrators can **activate**/**deactivate** user accounts and **manage user roles**. Accounts with `ADMIN` role are protected from these modifications.

<img src="screenshots/admin-dashboard.png" width="600"/>

---

## Demo Accounts

The application includes predefined demo users for evaluation and testing purposes.
These accounts are intended for local development and demonstration only.

| Role | Username | Password |
|------|----------|----------|
| Student | student | student |
| Company Mentor | mentor | mentor |
| Admin | admin | admin |

---

## Running the Project
```
docker compose up --build
```