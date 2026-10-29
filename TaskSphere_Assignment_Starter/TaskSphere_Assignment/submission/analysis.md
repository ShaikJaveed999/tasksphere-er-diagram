# TaskSphere — Debug a Broken ER Diagram (Challenge #1)

## Important note about the original design
The assignment instructions describe symptoms and common schema problems, but the pasted lesson text does not include the actual broken ER diagram or original SQL file. Therefore, the observations below are the likely issues to check against the repository's original files, not claims that every issue definitely appears in the original diagram.

## Likely issues, impact, and fixes

| Issue to check in the original schema | Impact | Fix in the redesigned schema |
|---|---|---|
| Missing primary keys | Rows may not be uniquely identifiable; updates and joins become unreliable. | Give each main entity a primary key. Use `(project_id, member_id)` as the composite key for project membership. |
| Missing foreign keys | Tasks or projects may refer to members/projects that do not exist. | Add foreign keys from `projects.owner_member_id`, `project_members` and `tasks` to their parent rows. |
| Duplicate project memberships | The same member may be added to the same project more than once, causing duplicate report rows. | Use the composite primary key on `project_members(project_id, member_id)`. |
| Duplicate member email addresses | One person could be represented by multiple accounts. | Add `UNIQUE` to `team_members.email`. |
| Repeated member/project details in task rows | Names and other descriptive data may disagree after updates, creating update anomalies. | Store member and project attributes once and reference them with foreign keys. |
| Many-to-many project/member relationship stored in one column or repeated columns | The schema becomes hard to query and cannot reliably enforce membership. | Use the junction table `project_members`. |
| No validation for status or role | Unexpected values can enter the database and complicate application logic. | Add `CHECK` constraints for task status and project role. |
| Missing indexes on frequently joined/filtered foreign keys | Queries can become slower as tables grow. | Add indexes on task project/assignee IDs and project membership/member IDs. |

## Redesigned structure
- `team_members`: canonical team member details.
- `projects`: project details and the member who owns each project.
- `project_members`: many-to-many link between projects and members.
- `tasks`: tasks belonging to projects, optionally assigned to a team member.

## Normalization notes
The design is intended to be close to Third Normal Form (3NF): each table represents one entity or relationship, non-key attributes describe that table's key, and member/project details are not copied into every task row. The junction table prevents duplicate memberships through its composite primary key.

## Assumptions to confirm
1. A task belongs to exactly one project.
2. A task can be unassigned or assigned to one team member.
3. A project can have many team members, and a member can join many projects.
4. Email addresses are unique.
5. Deleting a project deletes its tasks and membership rows; deleting an assigned member leaves the task but clears its assignee. Project owners cannot be deleted while their projects remain.

If the original schema has different business rules, adjust these assumptions before submitting.
