# Internship Management System

A Spring Boot application for managing internships, student applications, and role-based workflows in an academic–industry environment.

The system is built using Spring Boot, Spring Security, Thymeleaf, and PostgreSQL with strict role-based access control (RBAC).

---

## Architecture Overview

The underlying database schema is designed and maintained separately in the [internship-management-database](https://github.com/trifunovskanina/internship-management-database) repository.

The application validates the schema at startup and enforces business rules and access control on top of it.

---

## Technology Stack

- **Backend**: Spring Boot, Spring MVC, Spring Data JPA
- **Security**: Spring Security with custom authentication and role-based access control (RBAC)
- **Frontend**: Thymeleaf with minimal JavaScript
- **Database**: PostgreSQL
- **Deployment**: Docker & Docker Compose

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