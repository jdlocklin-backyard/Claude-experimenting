# 📐 Architecture & Concepts

This document explains the architecture and key concepts of the Claude agent and skill system.

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION                              │
│                                                                      │
│  "Using the ecommerce-backend-developer agent,                      │
│   implement a checkout endpoint"                                     │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                                 ↓
┌─────────────────────────────────────────────────────────────────────┐
│                        CLAUDE PROCESSES                              │
│                                                                      │
│  1. Parse request and identify agent reference                      │
│  2. Load configuration files as context                             │
│  3. Apply patterns and examples                                     │
│  4. Generate response following learned patterns                    │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ↓                         ↓
    ┌──────────────────────────┐  ┌──────────────────────────┐
    │   GLOBAL CONFIGS         │  │   PROJECT CONFIGS        │
    │   (.github/)             │  │   (.claude/)             │
    │                          │  │                          │
    │  • Base agents           │  │  • Domain agents         │
    │  • General skills        │  │  • Domain skills         │
    │  • Reusable patterns     │  │  • Project patterns      │
    │                          │  │  • Tech stack info       │
    └────────────┬─────────────┘  └─────────────┬────────────┘
                 │                              │
                 └──────────────┬───────────────┘
                                │
                                ↓
              ┌─────────────────────────────────┐
              │     COMBINED CONTEXT            │
              │                                 │
              │  Global foundation +            │
              │  Project specialization =       │
              │  Domain-aware output            │
              └─────────────────────────────────┘
```

---

## 🎭 Agent Hierarchy

### Inheritance Model

```
┌────────────────────────────────────────┐
│  GLOBAL AGENT                          │
│  (senior-developer)                    │
│                                        │
│  Provides:                             │
│  • General coding approach             │
│  • Decision framework                  │
│  • Base skills (code-reviewer,         │
│    test-generator)                     │
│  • Universal best practices            │
└──────────────┬─────────────────────────┘
               │
               │ extends
               │
               ↓
┌────────────────────────────────────────┐
│  PROJECT AGENT                         │
│  (ecommerce-backend-developer)         │
│                                        │
│  Adds:                                 │
│  • Domain knowledge (e-commerce)       │
│  • Tech stack (Node.js, Sequelize)     │
│  • Project patterns                    │
│  • Business rules                      │
│  • Domain skills (ecommerce-validator, │
│    database-migration)                 │
└────────────────────────────────────────┘
```

### Example Flow

```
User asks: "Implement checkout"
         ↓
Agent loads: ecommerce-backend-developer
         ↓
Which extends: senior-developer
         ↓
Gains capabilities from:
  • senior-developer (coding approach)
  • code-reviewer (quality checking)
  • test-generator (test creation)
  • ecommerce-validator (business rules)
  • database-migration (DB patterns)
         ↓
Understands:
  • General: error handling, documentation
  • Domain: pricing, inventory, orders
  • Tech: Sequelize, Express, PostgreSQL
  • Patterns: project conventions
         ↓
Generates: Domain-aware, pattern-following code
```

---

## 🛠️ Skill Composition

### How Skills Work Together

```
┌─────────────────────────────────────────────────────────────┐
│                    CODE TO REVIEW                           │
│                                                             │
│  function checkout(cartId, paymentId) {                     │
│    // implementation                                        │
│  }                                                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
         ┌─────────────┴─────────────┐
         │                           │
         ↓                           ↓
┌────────────────────┐    ┌────────────────────┐
│  GLOBAL SKILLS     │    │  PROJECT SKILLS    │
│                    │    │                    │
│  code-reviewer:    │    │  ecommerce-        │
│  • Security ✓      │    │  validator:        │
│  • Error handling ✓│    │  • Price calc ✓    │
│  • Performance ✓   │    │  • Inventory ✓     │
│  • Documentation ✓ │    │  • Tax rules ✓     │
│                    │    │  • Business logic ✓│
└────────────────────┘    └────────────────────┘
         │                           │
         └─────────────┬─────────────┘
                       │
                       ↓
          ┌────────────────────────┐
          │  COMBINED VALIDATION   │
          │                        │
          │  General + Domain =    │
          │  Comprehensive Review  │
          └────────────────────────┘
```

---

## 📂 File Organization

### Directory Structure Purpose

```
Repository Root
│
├── .github/                    # GLOBAL: Version-controlled, reusable
│   ├── agents/                # Agent personas for any project
│   │   ├── senior-developer.md
│   │   └── documentation-specialist.md
│   ├── skills/                # General-purpose capabilities
│   │   ├── code-reviewer.md
│   │   └── test-generator.md
│   └── README.md             # How to use global configs
│
├── .claude/                   # PROJECT: Specific to this codebase
│   ├── agents/               # Domain-specific agents
│   │   ├── ecommerce-backend-developer.md
│   │   └── api-documentation-agent.md
│   ├── skills/               # Domain-specific skills
│   │   ├── ecommerce-validator.md
│   │   └── database-migration.md
│   └── README.md            # How to use project configs
│
└── Documentation/            # User guides
    ├── README.md            # Overview
    ├── QUICK_START.md       # 5-min intro
    ├── INTERACTIVE_DEMO.md  # Complete walkthrough
    ├── IMPLEMENTATION_GUIDE.md  # Create your own
    └── ARCHITECTURE.md      # This file
```

### Why This Structure?

1. **Separation of Concerns**
   - Global = reusable foundations
   - Project = specific customizations

2. **Version Control**
   - Both directories are checked in
   - Team shares same configurations
   - Evolves with project

3. **Discoverability**
   - Clear hierarchy
   - Easy to find what you need
   - Well documented

---

## 🔄 Context Loading Flow

### How Claude Uses Configuration Files

```
1. USER REQUEST
   "Using ecommerce-backend-developer, implement checkout"
   
2. IDENTIFY AGENT
   Agent: ecommerce-backend-developer
   Location: .claude/agents/ecommerce-backend-developer.md
   
3. CHECK FOR INHERITANCE
   Extends: .github/agents/senior-developer
   Load: senior-developer.md as base
   
4. LOAD SKILLS (from both agents)
   From senior-developer:
     → Load .github/skills/code-reviewer.md
     → Load .github/skills/test-generator.md
   From ecommerce-backend-developer:
     → Load .claude/skills/ecommerce-validator.md
     → Load .claude/skills/database-migration.md
   
5. PARSE CONFIGURATION
   Extract:
   • Personality traits
   • Responsibilities
   • Decision frameworks
   • Examples and patterns
   • Tech stack information
   • Business rules
   
6. BUILD CONTEXT
   Combine all loaded information into cohesive context
   
7. GENERATE RESPONSE
   Apply learned patterns to user's request
   Follow examples from configuration files
   Use appropriate terminology and style
   
8. APPLY SKILLS (if reviewing)
   Run checks from each skill
   Combine feedback
   Return comprehensive results
```

---

## 💡 Key Concepts

### 1. Agents Are Context, Not Code

Agents don't execute code - they provide **context** that shapes how Claude responds.

```
Agent File = Instructions + Examples + Patterns
              ↓
         Claude's Context
              ↓
         Better Responses
```

### 2. Skills Are Guidelines, Not Tools

Skills define **what to check** and **how to check it**, not executable functions.

```
Skill File = Checklist + Examples + Standards
              ↓
         Claude's Awareness
              ↓
         Domain-Aware Validation
```

### 3. Examples Drive Behavior

The examples in configuration files directly influence output format.

```
Agent has example with:
  • Inline comments
  • Error handling
  • Specific structure
              ↓
Claude generates code with:
  • Inline comments
  • Error handling  
  • Same structure
```

### 4. Composition Over Duplication

Instead of duplicating, extend and compose:

```
❌ BAD: Duplicate senior-developer for each project

✅ GOOD: 
   Base: senior-developer (global)
   Extend: project-specific-developer (project)
   Result: Composed capabilities
```

---

## 🎯 Decision Points

### When to Create a Global Agent/Skill?

Create in `.github/` when:
- ✅ Applicable to ANY project
- ✅ No domain-specific knowledge needed
- ✅ General-purpose capability
- ✅ Want to reuse across projects

**Examples:**
- Code review
- Test generation
- Documentation writing
- Refactoring

### When to Create a Project Agent/Skill?

Create in `.claude/` when:
- ✅ Specific to your domain
- ✅ Requires business knowledge
- ✅ Tied to tech stack
- ✅ Project-specific patterns

**Examples:**
- E-commerce validator
- HIPAA compliance checker
- Industry-specific patterns
- Company conventions

### When to Extend vs Create New?

**Extend** when:
- Agent/skill mostly fits
- Need to add domain knowledge
- Want to inherit base capabilities

**Create New** when:
- Completely different role
- No existing agent fits
- Unique set of responsibilities

---

## 🔗 Interaction Patterns

### Pattern 1: Simple Agent Usage

```
User → Agent → Response

"Using senior-developer, implement login"
       ↓
   Loads agent
       ↓
   Generates code
```

### Pattern 2: Agent with Skills

```
User → Agent → Skills → Response

"Using senior-developer, implement and review login"
       ↓
   Loads agent
       ↓
   Loads agent's skills
       ↓
   Generates and validates code
```

### Pattern 3: Project Agent (Inheritance)

```
User → Project Agent → Global Agent → Skills → Response

"Using ecommerce-backend-developer, implement checkout"
       ↓
   Loads project agent
       ↓
   Extends global agent
       ↓
   Loads all skills (global + project)
       ↓
   Generates domain-aware code
```

### Pattern 4: Skill-Only Review

```
User → Skills → Response

"Review this code with ecommerce-validator"
       ↓
   Loads skill
       ↓
   Applies skill checks
       ↓
   Returns validation results
```

---

## 📊 Benefits by Role

### For Individual Developers
```
Agents/Skills → Consistent Output
             → Less Research Time
             → Fewer Mistakes
             → Better Quality
```

### For Teams
```
Shared Configs → Consistent Standards
              → Knowledge Sharing
              → Faster Onboarding
              → Enforced Patterns
```

### For Projects
```
Domain Context → Business Rules Applied
              → Tech Stack Alignment
              → Pattern Consistency
              → Compliance Adherence
```

---

## 🚀 Scaling Patterns

### Small Project (1-5 developers)
```
.github/           # Keep it simple
├── agents/
│   └── developer.md
└── skills/
    └── reviewer.md

.claude/           # Minimal customization
└── README.md
```

### Medium Project (5-20 developers)
```
.github/           # Shared foundations
├── agents/
│   ├── developer.md
│   ├── reviewer.md
│   └── documenter.md
└── skills/
    ├── code-reviewer.md
    └── test-generator.md

.claude/           # Domain-specific
├── agents/
│   ├── backend-dev.md
│   └── frontend-dev.md
└── skills/
    ├── domain-validator.md
    └── tech-checker.md
```

### Large Project (20+ developers)
```
.github/           # Organization-wide
├── agents/
│   ├── senior-dev.md
│   ├── tech-lead.md
│   ├── reviewer.md
│   └── documenter.md
└── skills/
    ├── code-reviewer.md
    ├── security-checker.md
    ├── performance-analyzer.md
    └── test-generator.md

.claude/           # Project-specific
├── agents/
│   ├── backend-dev.md
│   ├── frontend-dev.md
│   ├── api-dev.md
│   └── db-specialist.md
└── skills/
    ├── domain-validator.md
    ├── compliance-checker.md
    ├── migration-helper.md
    └── integration-tester.md
```

---

## 🎓 Learning Path

```
1. READ: Quick Start
   ↓
   Understand basics (agents, skills, usage)
   
2. EXPLORE: Interactive Demo
   ↓
   See real examples in action
   
3. UNDERSTAND: This Architecture Doc
   ↓
   Learn how it all works together
   
4. CREATE: Implementation Guide
   ↓
   Build your own configurations
   
5. REFINE: Iterate
   ↓
   Improve based on real usage
```

---

## 🔍 Troubleshooting

### Problem: Generic Output
**Cause:** Agent/skill not loaded or insufficient examples  
**Solution:** Add more specific examples in config files

### Problem: Wrong Patterns
**Cause:** Examples don't match desired output  
**Solution:** Update examples in agent files

### Problem: Missing Context
**Cause:** Project-specific information not in config  
**Solution:** Add tech stack, patterns to project agent

### Problem: Skills Not Applied
**Cause:** Skills not listed in agent or not explicitly invoked  
**Solution:** List skills in agent config, reference in prompts

---

## 📚 Additional Resources

- **Quick Start**: [QUICK_START.md](QUICK_START.md)
- **Interactive Demo**: [INTERACTIVE_DEMO.md](INTERACTIVE_DEMO.md)
- **Implementation Guide**: [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
- **Global Configs**: [.github/README.md](.github/README.md)
- **Project Configs**: [.claude/README.md](.claude/README.md)

---

**Understanding the architecture helps you create better configurations! 🏗️**
