# TaskSphere corrected ER diagram

```mermaid
erDiagram
    TEAM_MEMBERS ||--o{ PROJECTS : owns
    TEAM_MEMBERS ||--o{ PROJECT_MEMBERS : joins
    PROJECTS ||--o{ PROJECT_MEMBERS : includes
    PROJECTS ||--o{ TASKS : contains
    TEAM_MEMBERS o|--o{ TASKS : is_assigned

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
        TIMESTAMPTZ joined_at
        VARCHAR project_role
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
        TIMESTAMPTZ updated_at
    }
```

## Relationship summary
- One team member can own many projects; each project has one owner.
- Projects and team members have a many-to-many relationship through `project_members`.
- One project contains many tasks; each task belongs to one project.
- A team member can be assigned many tasks. A task may be unassigned or assigned to one member.
- `project_members` uses a composite primary key so the same member cannot be added to the same project twice.
