# Complaint-to-Resolution Workflow Database

## 📌 Project Title
**Complaint-to-Resolution Workflow Database using State Machine Reasoning**

## 📖 Description
A robust, normalised relational database system designed to manage the entire lifecycle of a complaint. Instead of merely storing complaints and allowing arbitrary status updates, this project implements a **Finite State Machine (FSM)** at the database level. It ensures that complaints transition logically through strict states (e.g., *Submitted → Acknowledged → In Progress → Resolved → Closed*) and only authorized users can trigger specific transitions.

## 🎯 Problem Statement
In many organizations, complaints are tracked via spreadsheets or basic databases where statuses can be changed arbitrarily (e.g., moving a complaint from "Submitted" directly to "Closed" without review). This lack of process discipline leads to poor accountability, skipped resolutions, and lost audit trails. This project solves this by enforcing workflow rules and maintaining an immutable audit log.

## ✨ Features
- **Role-Based Access Control**: Differentiates between Complainants, Admins, and Resolvers.
- **State Machine Enforcement**: Prevents invalid status jumps using a dedicated state transitions table.
- **Complete Audit Trail**: Every status change is logged with a timestamp, actor, and comment.
- **Fully Normalised (3NF)**: Eliminates data redundancy and transitive dependencies.
- **Complex Query Support**: Includes aggregate reporting, history tracking, and join operations.

## 🛠️ Tech Stack
- **Database:** MySQL / PostgreSQL
- **Design Tools:** Draw.io / Lucidchart (for ER Diagrams)
- **Backend (Optional):** Core Java / Python (for simulating state logic)

## 🔄 Workflow & State Machine Explanation
The core of this system is the State Machine. A complaint must flow logically:
1. **Submitted**: User files a complaint.
2. **Acknowledged**: Admin reviews and acknowledges it.
3. **In Progress**: Resolver is assigned and starts working.
4. **Pending Review**: Resolver submits a fix, awaiting Admin approval.
5. **Resolved**: Admin approves the fix.
6. **Closed**: Complainant accepts the resolution.

The database uses a `State_Transitions` table that acts as a rulebook, specifying which `from_status` can move to which `to_status`, and by which `role`.

## 🗄️ Database Design Overview
1. **Users**: Stores user details and roles.
2. **Status**: Dictionary of all possible states.
3. **State_Transitions**: The FSM rules mapping valid transitions.
4. **Complaints**: The central entity holding complaint details and current status.
5. **Complaint_History**: The audit log tracking every movement.

## 🚀 How to Run the Project
1. Install **MySQL Server** and a client like **MySQL Workbench** or **DBeaver**.
2. Run the DDL script: `source sql/schema.sql` to create tables.
3. Run the DML script: `source sql/sample_data.sql` to insert seed data.
4. Test the system using: `source sql/queries.sql`.
5. (Optional) Compile and run the `src/ComplaintWorkflow.java` file to test backend logic.

## 🔮 Future Improvements
- **Automated Triggers**: Implement SQL Triggers to strictly block invalid transitions natively without backend code.
- **SLA Tracking**: Add SLA deadlines and automate an "Escalated" status if deadlines are breached.
- **RESTful API**: Build a Spring Boot or Express.js API over the database.
