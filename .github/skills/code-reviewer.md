# Code Reviewer Skill

## Purpose
This skill provides code review capabilities to agents, enabling them to analyze code quality, identify issues, and suggest improvements.

## Skill Definition
**Skill Name:** code-reviewer  
**Type:** Analysis and Feedback  
**Scope:** Global (Available to all agents across all projects)

## Capabilities
- **Code Quality Analysis**: Review code for best practices, patterns, and potential issues
- **Security Scanning**: Identify potential security vulnerabilities
- **Performance Review**: Suggest optimizations and performance improvements
- **Documentation Check**: Ensure code is properly documented

## Usage Pattern
When an agent invokes this skill, it should:
1. Receive the code snippet or file path to review
2. Apply language-specific best practices
3. Check for common anti-patterns
4. Return structured feedback with severity levels

## Example Invocation
```yaml
# Agent using this skill would reference it like:
skills:
  - code-reviewer
  
# And invoke it with context:
task: "Review the authentication module for security issues"
context:
  - file: "src/auth/login.js"
  - focus: "security, input validation"
```

## Best Practices for This Skill
- **Be specific**: Focus on concrete, actionable feedback
- **Prioritize**: Rank issues by severity (critical, high, medium, low)
- **Explain**: Don't just identify issues, explain why they matter
- **Suggest**: Provide specific code suggestions when possible

## Interactive Example
```javascript
// CODE TO REVIEW:
function login(username, password) {
  return db.query("SELECT * FROM users WHERE username='" + username + "'");
}

// SKILL OUTPUT:
{
  "severity": "critical",
  "issue": "SQL Injection Vulnerability",
  "location": "line 2",
  "explanation": "Direct string concatenation in SQL query allows injection attacks",
  "suggestion": "Use parameterized queries: db.query('SELECT * FROM users WHERE username=?', [username])"
}
```

## Configuration Options
```json
{
  "strictness": "medium",  // low, medium, high
  "languages": ["javascript", "python", "java"],
  "checks": {
    "security": true,
    "performance": true,
    "style": false
  }
}
```

## How Models Use This Skill
When Claude encounters a code review request:
1. The agent's configuration specifies `skills: [code-reviewer]`
2. Claude loads this skill definition as context
3. The skill guidelines inform how Claude approaches the review
4. The examples provide patterns for response format
5. The configuration options allow customization per project

**Note:** This is a **global skill** - it's available to any agent in any project that references it.
