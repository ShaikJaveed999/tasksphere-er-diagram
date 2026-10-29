# TaskSphere corrected ER diagram

Paste the Mermaid source below, without the Markdown fences, into Mermaid Live to render it.

```mermaid
erDiagram
    TEAM_MEMBERS ||--o{ PROJECTS : owns
    TEAM_MEMBERS ||--o{ PROJECT_MEMBERS : joins
    PROJECTS ||--o{ PROJECT_MEMBERS : includes
    PROJECTS ||--o{ TASKS : contains
    TEAM_MEMBERS ||--o{ TASKS : assigned_to

    TEAM_MEMBERS {
        BIGINT member_id PK
        VARCHAR full_name
        VARCHAR email UK
        TIMESTAMPTZ created_at
    }
    PROJECTS {
        BIGINT project_id PK
        VARCHAR project_name
        TEXT description
        BIGINT owner_member_id FK
        TIMESTAMPTZ created_at
    }
    PROJECT_MEMBERS {
        BIGINT project_id PK, FK
        BIGINT member_id PK, FK
        TIMESTAMPTZ added_at
    }
    TASKS {
        BIGINT task_id PK
        BIGINT project_id FK
        BIGINT assigned_member_id FK
        VARCHAR task_title
        TEXT task_description
        VARCHAR status
        DATE due_date
        TIMESTAMPTZ created_at
    }
```

## Relationships and constraints

- A team member may own zero or more projects; every project has exactly one owner.
- Projects and team members have a many-to-many membership relationship through `project_members`. Its `(project_id, member_id)` composite primary key prevents a member from joining the same project more than once.
- Each task belongs to exactly one project. A member may be assigned many tasks, while a task may be unassigned or assigned to one member.
- `team_members.email` is unique. Task status is restricted to `todo`, `in_progress`, `done`, or `blocked`.
- The ERD shows all columns, primary keys, unique email, foreign keys, and relationships. Nullability, default values, check constraints, and deletion/update actions are defined in [schema.sql](schema.sql).
