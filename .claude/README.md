# Project-Specific Claude Configurations

This directory contains **project-specific** agent and skill definitions for an **e-commerce application**.

## 📁 Directory Structure

```
.claude/
├── agents/                          # Project-specific agents
│   ├── ecommerce-backend-developer.md
│   └── api-documentation-agent.md
└── skills/                         # Project-specific skills
    ├── ecommerce-validator.md
    └── database-migration.md
```

## 🎯 Purpose

This folder demonstrates how to **extend and customize** global agents and skills for a specific project. These configurations:

- **Inherit** from global definitions in `.github/`
- **Add** project-specific knowledge and constraints
- **Customize** behavior for the e-commerce domain
- **Reference** project tech stack and patterns

## 🎭 Project-Specific Agents

### 1. E-Commerce Backend Developer (`ecommerce-backend-developer.md`)

**Extends:** `.github/agents/senior-developer.md`

**Additional Context:**
- E-commerce domain knowledge
- Tech stack: Node.js, Express, PostgreSQL, Redis, Stripe
- Business rules for pricing, inventory, and orders

**Additional Skills:**
- ecommerce-validator
- database-migration

**Use when:**
- Implementing checkout flows
- Building product catalogs
- Managing inventory
- Processing payments

### 2. API Documentation Agent (`api-documentation-agent.md`)

**Extends:** `.github/agents/documentation-specialist.md`

**Additional Context:**
- REST API documentation focus
- OpenAPI/Swagger format
- Multi-language examples (curl, JavaScript, Python)

**Additional Skills:**
- ecommerce-validator (to ensure examples are valid)

**Use when:**
- Documenting API endpoints
- Creating OpenAPI specifications
- Writing integration guides

## 🛠️ Project-Specific Skills

### 1. E-Commerce Validator (`ecommerce-validator.md`)

**Type:** Business Logic Validation  
**Domain:** E-commerce

**Validates:**
- Price precision and calculations
- Inventory tracking logic
- Discount and tax rules
- Order processing flows

**Example checks:**
```javascript
✓ Prices use proper decimal precision
✓ Discounts cannot create negative prices
✓ Inventory updates are atomic
✓ Tax calculated by location
```

### 2. Database Migration (`database-migration.md`)

**Type:** Database Operations  
**Supports:** PostgreSQL with Sequelize

**Validates:**
- Migration reversibility
- Data safety
- Performance impact
- Production readiness

**Example checks:**
```javascript
✓ Has both up() and down() functions
✓ No data loss possible
✓ Uses transactions
✓ Indexes added concurrently
```

## 🔗 How Project and Global Work Together

### Agent Inheritance
```
.github/agents/senior-developer.md (GLOBAL)
    ↓ (extends)
.claude/agents/ecommerce-backend-developer.md (PROJECT)
    ↓ (combines)
Result: Senior dev skills + E-commerce knowledge
```

### Skill Composition
```
Agent loads skills:
1. code-reviewer (global)
2. test-generator (global)  
3. ecommerce-validator (project)
4. database-migration (project)

Result: General + Domain-specific capabilities
```

## 📝 Usage Examples

### Example 1: Implementing Checkout
```
Prompt: "Using the ecommerce-backend-developer agent, 
        implement the checkout endpoint"

Claude will:
1. Load global senior-developer agent
2. Load project ecommerce-backend-developer (extends global)
3. Load skills: code-reviewer, test-generator, 
   ecommerce-validator, database-migration
4. Apply e-commerce patterns and tech stack knowledge
5. Generate code that follows project conventions
```

### Example 2: Documenting an API
```
Prompt: "Using the api-documentation-agent, document the 
        GET /products endpoint"

Claude will:
1. Load global documentation-specialist agent
2. Load project api-documentation-agent (extends global)
3. Apply OpenAPI format
4. Generate examples in multiple languages
5. Validate examples with ecommerce-validator skill
```

## 🎯 Project Context in Action

### Tech Stack Awareness
When agents work in this project, they know:
- **Backend:** Node.js + Express
- **Database:** PostgreSQL with Sequelize ORM
- **Cache:** Redis
- **Payments:** Stripe
- **Auth:** JWT with refresh tokens

### Coding Conventions
Agents automatically follow project patterns:
```javascript
// Use Sequelize models
const user = await User.findByPk(userId);

// Wrap multi-step ops in transactions
const transaction = await sequelize.transaction();

// Store prices as decimals
price: Sequelize.DECIMAL(10, 2)

// Use consistent error responses
return res.status(400).json({ error: 'Invalid input' });
```

### Business Rules
Agents understand e-commerce domain:
- Prices calculated server-side, never trust client
- Inventory updates must be atomic
- Orders need idempotency keys
- Tax depends on customer location
- Payment failures must rollback inventory

## ✨ Customization Benefits

| Without Project Config | With Project Config |
|----------------------|-------------------|
| Generic code examples | Project-specific patterns |
| General best practices | Domain-specific rules |
| May need corrections | Follows project conventions |
| Requires clarification | Understands business context |

## 🚀 Quick Start

1. **Review global configs** in `.github/` first
2. **See how they're extended** in project configs
3. **Try the interactive demo** in `INTERACTIVE_DEMO.md`
4. **Adapt for your project** using `IMPLEMENTATION_GUIDE.md`

## 📋 Creating Your Own Project Configs

Follow these steps:

### 1. Identify Your Domain
What makes your project unique?
- E-commerce? Healthcare? Social media?
- What business rules matter?

### 2. Choose Global Base
Which global agent fits best?
- Implementation → senior-developer
- Documentation → documentation-specialist

### 3. Add Project Context
```yaml
extends: .github/agents/senior-developer
project_context:
  domain: "your-domain"
  stack:
    backend: "your-backend"
    database: "your-database"
  patterns:
    # Your patterns
```

### 4. Create Project Skills
What domain-specific validations do you need?
- Business rules?
- Compliance requirements?
- Industry standards?

## 🔍 Real-World Impact

### Before Project Configs
```
Claude: "Here's a checkout function"
You: "We use Sequelize, not raw SQL"
You: "Need to check inventory first"
You: "Must use transactions"
You: "Price should be from database, not request"
```

### After Project Configs
```
Claude: "Here's a checkout function"
[Generated code already:]
- Uses Sequelize ORM
- Checks inventory in transaction
- Calculates price server-side
- Follows project patterns
```

## 💡 Tips

1. **Start with global agents** - Only customize what's unique
2. **Document your patterns** - Include real code examples
3. **Keep it focused** - Project configs should be specific
4. **Update as needed** - Keep in sync with project evolution
5. **Test the configs** - Try them in real tasks

---

**🎓 Remember:** Global configs provide foundation, project configs provide specialization!
