# 3–5 minute video explanation script

Hello, in this video I will explain my solution for the TaskSphere broken ER diagram challenge.

TaskSphere manages projects, tasks, and team members. The assignment describes duplicate records, tasks referencing users that do not exist, and slow queries. These symptoms can be caused by missing primary keys, missing foreign keys, duplicate relationships, redundant data, and missing indexes.

I redesigned the database using four tables: team_members, projects, project_members, and tasks.

First, team_members stores each team member once. The member_id is its primary key, and email is unique so the same email cannot be registered more than once.

Second, projects stores each project and its owner. owner_member_id is a foreign key referencing team_members. This prevents a project from referring to an owner who does not exist.

Third, project_members handles the many-to-many relationship between projects and team members. A project can have multiple members, and a member can join multiple projects. The composite primary key made from project_id and member_id prevents duplicate membership records.

Fourth, tasks stores task details. Each task references a project through project_id. assigned_member_id references a valid team member and can be empty when a task has not yet been assigned. The status column has a CHECK constraint so only supported statuses can be saved.

I also added indexes to foreign-key columns that are likely to be used in joins and filters. These indexes can improve query performance as the database grows.

The design reduces redundancy by storing member and project details in their own tables instead of repeating those details in task records. This helps avoid inconsistent updates and supports a structure closer to Third Normal Form.

The SQL file creates the tables, primary keys, foreign keys, uniqueness rules, validation checks, and indexes. The ER diagram shows the same relationships visually.

Thank you for watching.
