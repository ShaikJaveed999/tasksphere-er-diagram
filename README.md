# TaskSphere — Database Schema Design

## Project Overview

TaskSphere is a project management system that manages projects, tasks, and team members.

This project focuses on identifying database design problems and creating an improved relational database schema.

## Database Tables

The redesigned schema contains four tables:

1. **TEAM_MEMBERS** — Stores team member information.
2. **PROJECTS** — Stores project details and project owners.
3. **PROJECT_MEMBERS** — Connects team members to projects.
4. **TASKS** — Stores tasks and their assignments.

## Improvements

* Primary keys uniquely identify records.
* Foreign keys enforce relationships between tables.
* Unique constraints prevent duplicate email addresses and duplicate project memberships.
* Check constraints validate task statuses and project roles.
* Indexes support commonly used queries.

## Submission Files

* `schema.sql` — Corrected PostgreSQL schema.
* `erd.md` — Mermaid source code for the ER diagram.
* `corrected-erd.png` — Exported ER diagram image.
* `analysis.md` — Database issues and proposed solutions.

## Technologies

* PostgreSQL
* SQL
* Mermaid ER diagrams
* GitHub
