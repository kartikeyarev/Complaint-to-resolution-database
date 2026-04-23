# Database Management System Mini Project Report

## 1. Abstract
This project presents a robust Relational Database Management System (RDBMS) for tracking organizational complaints. The unique aspect of this system is the implementation of a "Finite State Machine" (FSM) at the database schema level. It prevents arbitrary status updates and ensures all complaints follow a strict, auditable workflow from submission to resolution, reducing dropped cases and ensuring accountability.

## 2. Introduction
Complaint management systems often suffer from data inconsistency due to a lack of rigid workflow enforcement. Users or admins might accidentally close a ticket without resolving it, or skip necessary approval steps. This project utilizes DBMS concepts like Normalization, Foreign Key Constraints, and State Machine Logic to enforce a foolproof workflow backed by a comprehensive audit trail.

## 3. Objectives
1. Design a fully normalized relational database schema (3NF).
2. Implement an FSM to strictly control the lifecycle of a complaint.
3. Track and maintain a tamper-evident audit log of all changes.
4. Support complex querying for administrative oversight and reporting.

## 4. System Overview
The system involves three main actors:
- **Complainant**: Submits complaints and can close them once resolved.
- **Admin**: Acknowledges complaints, assigns resolvers, and approves final resolutions.
- **Resolver**: Works on the complaint and submits findings for review.

### State Transitions Supported:
`Submitted` → `Acknowledged` → `In Progress` → `Pending Review` → `Resolved` → `Closed`

## 5. ER Model (Textual Representation)
- **USERS**: Has a 1-to-Many relationship with Complaints (as creator).
- **USERS**: Has a 1-to-Many relationship with Complaints (as assigned resolver).
- **STATUS**: Has a 1-to-Many relationship with Complaints (defining current state).
- **STATE_TRANSITIONS**: Acts as a mapping table between two Statuses, defining rules.
- **COMPLAINT_HISTORY**: Has a Many-to-1 relationship with Complaints, Users, and Status.

## 6. Relational Schema
- `Users(user_id PK, full_name, email, role, created_at)`
- `Status(status_id PK, status_name, is_final)`
- `State_Transitions(transition_id PK, from_status_id FK, to_status_id FK, allowed_role)`
- `Complaints(complaint_id PK, user_id FK, title, description, status_id FK, assigned_to FK, created_at, updated_at)`
- `Complaint_History(log_id PK, complaint_id FK, changed_by FK, old_status_id FK, new_status_id FK, comments, changed_at)`

## 7. Normalization (Up to 3NF)
- **1NF**: All columns contain atomic values. No repeating groups. Primary keys are defined.
- **2NF**: All tables use a single-column surrogate Primary Key (Auto Increment INT). Therefore, partial dependencies are inherently eliminated.
- **3NF**: There are no transitive dependencies. For instance, the actual string value of a status is not stored in the `Complaints` table; only the `status_id` is stored, referencing the `Status` table.

## 8. State Machine Logic
By utilizing the `State_Transitions` table, the backend or database triggers can cross-reference any UPDATE request. 
If User A (role: Resolver) tries to change a complaint from 'Submitted' directly to 'Resolved', the database query will check `State_Transitions` and find no rule permitting a Resolver to make that jump, thus rejecting the update.

## 9. Advantages, Limitations, and Future Scope
**Advantages**: High data integrity, perfect audit trails, logical process enforcement.
**Limitations**: Purely relational state machine can require complex sub-queries to validate transitions before updating.
**Future Scope**: Implementing SQL Triggers (BEFORE UPDATE) to natively reject invalid transitions without requiring backend application logic to check first.
