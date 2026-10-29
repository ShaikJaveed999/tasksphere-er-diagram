-- TaskSphere: corrected relational schema
-- Assumption: one task belongs to one project and can be assigned to zero or one team member.
-- A project can have multiple members; project membership is represented by a junction table.
-- SQL dialect: PostgreSQL

BEGIN;

CREATE TABLE team_members (
    member_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projects (
    project_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    description TEXT,
    owner_member_id BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_projects_owner
        FOREIGN KEY (owner_member_id)
        REFERENCES team_members(member_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT uq_projects_owner_name UNIQUE (owner_member_id, project_name)
);

CREATE TABLE project_members (
    project_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    project_role VARCHAR(30) NOT NULL DEFAULT 'member',
    CONSTRAINT pk_project_members PRIMARY KEY (project_id, member_id),
    CONSTRAINT fk_project_members_project
        FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_project_members_member
        FOREIGN KEY (member_id)
        REFERENCES team_members(member_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_project_role
        CHECK (project_role IN ('owner', 'admin', 'member'))
);

CREATE TABLE tasks (
    task_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id BIGINT NOT NULL,
    assigned_member_id BIGINT,
    task_title VARCHAR(200) NOT NULL,
    task_description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'todo',
    due_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasks_project
        FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_tasks_assignee
        FOREIGN KEY (assigned_member_id)
        REFERENCES team_members(member_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT chk_task_status
        CHECK (status IN ('todo', 'in_progress', 'done', 'blocked'))
);

-- Index foreign-key columns commonly used in joins and filters.
CREATE INDEX idx_projects_owner_member_id ON projects(owner_member_id);
CREATE INDEX idx_project_members_member_id ON project_members(member_id);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_assigned_member_id ON tasks(assigned_member_id);
CREATE INDEX idx_tasks_status ON tasks(status);

COMMIT;
