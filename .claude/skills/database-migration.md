# Database Migration Skill

## Purpose
This is a PROJECT-SPECIFIC skill for creating, reviewing, and managing database migrations safely.

## Skill Definition
**Skill Name:** database-migration  
**Type:** Database Operations  
**Scope:** Project (For projects with database migrations)

## Capabilities
- **Migration Creation**: Generate safe, reversible database migrations
- **Schema Review**: Validate migration scripts for safety and correctness
- **Rollback Planning**: Ensure every migration has a working rollback
- **Data Preservation**: Verify that migrations don't lose data
- **Performance Analysis**: Check for migrations that could cause downtime

## Usage Pattern
This skill helps create and validate database migrations:
1. Generate migration scripts that are safe to run in production
2. Ensure migrations are reversible (have proper down/rollback)
3. Check for potential data loss scenarios
4. Validate that indexes are added properly
5. Ensure migrations can run with minimal downtime

## Example Invocation
```yaml
skills:
  - database-migration

task: "Create migration to add user preferences table"
context:
  - database: "PostgreSQL"
  - orm: "Sequelize"
  - requirements: "Add user_preferences table with foreign key to users"
```

## Best Practices for This Skill
- **Always Reversible**: Every `up` migration must have a working `down`
- **Data Safety**: Never drop columns with data without backup plan
- **Index Management**: Add indexes concurrently in production databases
- **Naming Convention**: Use timestamps and descriptive names
- **Test First**: Run migrations on staging before production
- **Batching**: Break large data migrations into smaller batches

## Interactive Example

**Migration Request:**
> "Add email_verified column to users table, default to false"

**Generated Migration:**
```javascript
/**
 * Migration: Add email verification to users
 * Created: 2024-01-15
 * 
 * Changes:
 * - Adds email_verified boolean column to users table
 * - Defaults to false for new users
 * - Sets false for all existing users (safe default)
 * 
 * Rollback: Removes the email_verified column
 * 
 * Performance Impact: LOW
 * - ALTER TABLE is fast for boolean columns
 * - No data transformation needed
 * 
 * Data Safety: HIGH
 * - No data loss possible
 * - Reversible without data loss
 */

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('users', 'email_verified', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
      comment: 'Whether user has verified their email address'
    });
    
    // Create index for faster queries on email verification status
    await queryInterface.addIndex('users', ['email_verified'], {
      name: 'idx_users_email_verified',
      // Use CONCURRENT in production to avoid table locks
      concurrently: true
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Remove index first
    await queryInterface.removeIndex('users', 'idx_users_email_verified');
    
    // Remove column
    await queryInterface.removeColumn('users', 'email_verified');
  }
};
```

**Safety Review Output:**
```json
{
  "safetyChecks": {
    "reversible": "✓ PASS - Down migration properly removes changes",
    "dataLoss": "✓ PASS - No existing data will be lost",
    "performanceImpact": "✓ PASS - Low impact, no table locks",
    "productionReady": "✓ PASS - Safe for production deployment"
  },
  "recommendations": [
    "Test on staging database first",
    "Run during low-traffic period if possible",
    "Monitor query performance after index addition"
  ],
  "estimatedDuration": "< 1 second for 1M rows"
}
```

## Migration Safety Checklist
When creating or reviewing migrations:
- [ ] Has both `up` and `down` functions
- [ ] Down migration successfully reverses up migration
- [ ] No data loss in forward migration
- [ ] No data loss in rollback
- [ ] Uses transactions where possible
- [ ] Adds indexes concurrently for large tables
- [ ] Column renames handled with backward compatibility
- [ ] Foreign keys have proper constraints
- [ ] Default values are specified for new columns
- [ ] Migration is idempotent (safe to run multiple times)

## Dangerous Patterns to Avoid
```javascript
// ❌ BAD: Data loss without backup
up: async (queryInterface) => {
  await queryInterface.removeColumn('users', 'old_address');
}

// ✅ GOOD: Preserve data before removal
up: async (queryInterface) => {
  // First, copy data to new column
  await queryInterface.sequelize.query(
    'UPDATE users SET new_address = old_address WHERE old_address IS NOT NULL'
  );
  // Then remove old column in a FUTURE migration after verification
}

// ❌ BAD: Blocking index creation
await queryInterface.addIndex('large_table', ['user_id']);

// ✅ GOOD: Non-blocking index creation
await queryInterface.addIndex('large_table', ['user_id'], {
  concurrently: true  // PostgreSQL
});

// ❌ BAD: Non-reversible rename
up: async (queryInterface) => {
  await queryInterface.renameColumn('users', 'name', 'full_name');
}
down: async (queryInterface) => {
  // Missing reverse rename!
}

// ✅ GOOD: Properly reversible
up: async (queryInterface) => {
  await queryInterface.renameColumn('users', 'name', 'full_name');
}
down: async (queryInterface) => {
  await queryInterface.renameColumn('users', 'full_name', 'name');
}
```

## Configuration Options
```json
{
  "database": "postgresql",     // postgresql, mysql, mongodb
  "orm": "sequelize",           // sequelize, typeorm, prisma
  "naming": "timestamp",        // timestamp, sequential
  "safetyLevel": "strict",      // strict, moderate, permissive
  "requireReversible": true,
  "requireComments": true,
  "checkDataLoss": true
}
```

## How Models Use This Skill
When Claude generates or reviews migrations:
1. **Safety First**: Always prioritize data safety and reversibility
2. **Performance Aware**: Consider impact on production databases
3. **Documentation**: Include clear comments explaining changes
4. **Best Practices**: Apply database-specific optimization techniques
5. **Testing Guidance**: Provide instructions for testing migrations

## Migration Workflow
```
1. REQUEST
   └─> Define what needs to change in the database

2. GENERATE
   └─> Create migration with up/down functions
   └─> Add safety comments and documentation

3. REVIEW
   └─> Check against safety checklist
   └─> Identify potential issues
   └─> Suggest improvements

4. TEST
   └─> Run on local database
   └─> Test rollback works
   └─> Verify data integrity

5. DEPLOY
   └─> Run on staging
   └─> Monitor for issues
   └─> Deploy to production
```

**Note:** This is a **PROJECT-SPECIFIC skill** - different projects use different databases and ORMs, so this skill should be configured per-project.
