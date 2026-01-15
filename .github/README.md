# Global Claude Configurations

This directory contains **global** agent and skill definitions that can be used across **all projects**.

## 📁 Directory Structure

```
.github/
├── agents/           # Global agent personas
│   ├── senior-developer.md
│   └── documentation-specialist.md
└── skills/          # Global skill capabilities
    ├── code-reviewer.md
    └── test-generator.md
```

## 🎭 What Are Agents?

**Agents** are personas or roles that Claude can adopt when working on tasks. Think of them as job titles with specific:
- Responsibilities and goals
- Decision-making frameworks
- Personality traits and approaches
- Access to specific skills

### Available Global Agents

#### 1. Senior Developer (`senior-developer.md`)
A general-purpose coding agent for implementation, refactoring, and architecture.

**Use when you need:**
- Code implementation
- Refactoring existing code
- Architecture decisions
- Code reviews

**Skills available:**
- code-reviewer
- test-generator

#### 2. Documentation Specialist (`documentation-specialist.md`)
Focused on creating clear, comprehensive technical documentation.

**Use when you need:**
- API documentation
- User guides and tutorials
- README files
- Code comments

**Skills available:**
- code-reviewer (for validating examples)

## 🛠️ What Are Skills?

**Skills** are specific capabilities or tools that agents can use. Think of them as specialized knowledge areas.

### Available Global Skills

#### 1. Code Reviewer (`code-reviewer.md`)
Analyzes code for quality, security, and best practices.

**Capabilities:**
- Quality analysis
- Security scanning
- Performance review
- Documentation checking

#### 2. Test Generator (`test-generator.md`)
Automatically generates comprehensive test cases.

**Capabilities:**
- Unit test generation
- Edge case identification
- Mock creation
- Test data generation

## 🎯 How Models Use These Files

When you reference an agent or skill, Claude:

1. **Loads the definition** as context
2. **Adopts the persona** (for agents) or **gains the capability** (for skills)
3. **Follows the patterns** and examples provided
4. **Applies the best practices** defined in the file
5. **Formats output** according to the examples

### Example Flow

```
User: "Review this authentication code"
    ↓
Claude loads: senior-developer agent
    ↓
Agent specifies: code-reviewer skill
    ↓
Claude loads: code-reviewer skill
    ↓
Claude applies: Security scanning patterns from skill
    ↓
Claude responds: Using format shown in examples
```

## 📝 Using Global Configurations

### In Conversations
Simply reference the agent:
```
"Act as the senior developer agent and implement user authentication"
```

### In Project Configurations
Reference global agents in project-specific configs:
```yaml
# In .claude/agents/my-project-agent.yml
extends: .github/agents/senior-developer
additional_skills:
  - my-project-skill
```

## ✨ Best Practices

1. **Keep global definitions general-purpose** - Don't include project-specific details
2. **Provide clear examples** - Show exactly what output should look like
3. **Document decision frameworks** - Explain how to approach problems
4. **Include inline notes** - Help users understand the patterns
5. **Make them composable** - Allow project overrides and extensions

## 🔄 Global vs Project Configurations

| Aspect | Global (.github/) | Project (.claude/) |
|--------|------------------|-------------------|
| **Scope** | All projects | Single project |
| **Content** | General patterns | Specific rules |
| **Examples** | Generic code | Project code |
| **Portability** | Reusable | Project-specific |

## 🚀 Quick Start

1. **Browse the agents** - See what personas are available
2. **Read the skills** - Understand what capabilities exist
3. **Try an example** - Reference an agent in a task
4. **Customize for your project** - Create project-specific overrides in `.claude/`

## 📚 Next Steps

- See `.claude/README.md` for project-specific configurations
- See `INTERACTIVE_DEMO.md` for a complete walkthrough
- See `IMPLEMENTATION_GUIDE.md` for how to create your own agents/skills

---

**💡 Tip:** These global configurations are your foundation. Build project-specific configurations on top of them!
