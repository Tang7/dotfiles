---
name: "Database Migration"
description: "Generate and review database migration files when user wants to add, modify, or remove database tables or columns"
allowed-tools: ["Read", "Write", "Bash"]
---

When the user asks to create or modify database migrations, follow these steps:

1. Check existing migration files for naming conventions
   - Read the migrations directory to find the latest migration number
   - Follow the pattern: `NNNN_description.sql`

2. Generate the new migration file
   - Write the UP migration (the change)
   - Write the DOWN migration (the rollback)

3. Add rollback logic automatically
   - Every `CREATE TABLE` gets a `DROP TABLE` in DOWN
   - Every `ADD COLUMN` gets a `DROP COLUMN` in DOWN

4. Run a dry-run validation
   - Confirm the SQL is syntactically valid
   - Check for missing indexes on foreign keys
