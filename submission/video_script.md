# Video explanation script (approximately 3–4 minutes)

Hello. This is my solution to the TaskSphere “Debug a Broken ER Diagram” challenge. TaskSphere manages projects, tasks, and team members. I reviewed both files provided by the assignment: the ER diagram and the SQL schema. That matters because the diagram and SQL do not agree in every place.

The first confirmed problem is that none of the original tables declares a primary key. The `UserProjects` table is just a pair of names, so the database has no rule preventing the same member from being listed on the same project multiple times. That can produce duplicate rows in membership reports.

The original tables also connect records using names rather than stable identifiers. For example, a project stores `owner_name`, and a task stores `project_name` and `assigned_user`. There are no foreign keys. As a result, a misspelling or a user who does not exist can be stored in those columns. Repeating names also makes renames and updates harder to keep consistent.

There are SQL problems as well. The schema uses types such as `ID(100)`, `VAR(100)`, and `INT(100)`, which are not valid built-in PostgreSQL declarations. Also, the SQL says `task_name` is an integer, while the ER diagram shows it as a string. That means the original SQL is not a reliable implementation of the diagram.

My corrected design has four tables. `team_members` stores each team member once. It has a generated `member_id` primary key, a required name and email, and a unique constraint on email. Email uniqueness is a design choice; the source does not explicitly require it.

`projects` stores the project name and optional description. Each project has one owner, recorded as `owner_member_id`, a foreign key back to `team_members`. The foreign key prevents a project from having an owner ID that does not exist. Deleting an owner is restricted while that person still owns a project.

The many-to-many relationship between team members and projects is represented by `project_members`. Its two foreign keys point to the member and project. Together, `project_id` and `member_id` form a composite primary key, so the same member-project pair cannot be inserted twice. Deleting a project or a member removes the related membership rows.

The `tasks` table has its own primary key, a required project foreign key, and an optional assignee foreign key. A task may be unassigned, but when an assignee is provided that member must exist. Deleting an assigned member clears the assignee instead of deleting the task. Deleting the project deletes its tasks, because those tasks belong to that project.

I added `NOT NULL` constraints to required values and a check constraint limiting status to `todo`, `in_progress`, `done`, or `blocked`. The original files do not define allowed statuses, so this list is a stated design assumption. I also added indexes for foreign-key columns used in joins. The membership table's composite primary key already indexes `project_id` as its first column, so I did not add a duplicate index for that column.

Finally, the design is closer to Third Normal Form because member and project facts are stored once, and the relationship tables refer to them by IDs. That helps prevent inconsistent name updates and gives the database a way to enforce relationships. The assignment mentions slower queries, but I cannot prove the original missing indexes caused that symptom without workload measurements. My design addresses the clear schema risks and supplies a consistent ER diagram and PostgreSQL schema.
