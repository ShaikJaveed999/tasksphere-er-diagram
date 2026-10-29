# TaskSphere — Debug a Broken ER Diagram

This repository contains the completed deliverables for Kalvium Project Engineering assignment **4.6 — Debug a Broken ER Diagram | Challenge #1**. The design is based on the actual broken ERD and SQL schema in the [original assignment repository](https://github.com/kalviumcommunity/Project-Engineering/tree/main/Milestone-03/Debug%20a%20Broken%20ER%20Diagram).

## What was wrong in the original design

The supplied schema has no primary keys, foreign keys, unique constraints, or indexes. It stores owner, project, and assignee references as names rather than stable identifiers; the `UserProjects` pair is not protected against duplicate memberships. Some SQL types (`ID(100)`, `VAR(100)`, and `INT(100)`) are not valid PostgreSQL type declarations, and the ERD disagrees with the SQL about the type of `Tasks.task_name`. See [submission/analysis.md](submission/analysis.md) for evidence, impact, and corrections. The absence of indexes is confirmed; its contribution to the reported slow queries is a likely risk, not something proven without workload measurements.

## Corrected design

The proposed PostgreSQL schema has four tables:

- `team_members` — one row per team member, with a primary key and unique email.
- `projects` — one row per project, with a required owner foreign key.
- `project_members` — a many-to-many junction table whose composite primary key prevents duplicate membership.
- `tasks` — one row per task, linked to exactly one project and optionally to one existing assignee.

Foreign keys, `NOT NULL`, `UNIQUE`, and `CHECK` constraints enforce the stated rules. Indexes support joins through foreign-key columns not already covered by a primary-key index. Member and project descriptions are stored once, rather than duplicated in task and membership rows, making the structure closer to Third Normal Form. See [submission/erd.md](submission/erd.md) and [submission/schema.sql](submission/schema.sql).

## Deliverables

- [submission/corrected-erd.png](submission/corrected-erd.png) — exported ER diagram.
- [submission/erd.md](submission/erd.md) — Mermaid ER diagram source and relationship notes.
- [submission/schema.sql](submission/schema.sql) — corrected PostgreSQL schema.
- [submission/analysis.md](submission/analysis.md) — evidence-based findings, impacts, fixes, and assumptions.
- [submission/video_script.md](submission/video_script.md) — a 3–5 minute explanation script.

## Inspect and validate

Open `submission/erd.md` and paste only the content inside its Mermaid code block into [Mermaid Live](https://mermaid.live). The PNG is a separately exported diagram, not an editor screenshot.

To execute the schema, use a disposable PostgreSQL database that you control, not a production database:

```powershell
psql -v ON_ERROR_STOP=1 --dbname=YOUR_TEST_DATABASE --file=submission/schema.sql
```

The schema is wrapped in a transaction. The database must be empty of tables with these names, or execution will fail rather than overwrite them. Checks performed for this submission: the PostgreSQL grammar parsed successfully using `pglast`; all four ERD entities and their columns were checked against the SQL; the Mermaid source rendered in Mermaid Live without syntax errors; the separately exported PNG was verified as an 1850 × 1400 PNG; required constraints and files were checked; and `git diff --check` completed cleanly. No PostgreSQL server/client was available, so the SQL was not executed against a live database. No automated test suite is configured in this repository.
