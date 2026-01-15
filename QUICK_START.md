# ⚡ Quick Start Guide

Get started with Claude agents and skills in **5 minutes**!

## 🎯 What You'll Learn

1. How to reference an agent
2. How to use skills
3. How to combine them for powerful results

## 📋 Prerequisites

None! Just read and try.

## 🚀 Step 1: Understand the Basics (1 min)

### Agents = Personas
Think "job title" - what role should Claude play?

**Available Global Agents:**
- `senior-developer` - For coding tasks
- `documentation-specialist` - For writing docs

**Available Project Agents (E-commerce):**
- `ecommerce-backend-developer` - E-commerce coding
- `api-documentation-agent` - API docs

### Skills = Capabilities
Think "specialized knowledge" - what tools can the agent use?

**Available Global Skills:**
- `code-reviewer` - Analyze code quality
- `test-generator` - Create test cases

**Available Project Skills (E-commerce):**
- `ecommerce-validator` - Business logic validation
- `database-migration` - Database changes

## 🎮 Step 2: Try Basic Examples (2 min)

### Example 1: Use a Global Agent
```
Prompt: "Using the senior-developer agent, 
         create a function to validate email addresses"

Result: Claude generates well-structured code with:
- Input validation
- Error handling
- Clear documentation
- Following best practices
```

### Example 2: Use a Project Agent
```
Prompt: "Using the ecommerce-backend-developer agent,
         create a function to calculate order totals"

Result: Claude generates e-commerce-aware code with:
- Server-side price calculation
- Tax calculation by location
- Discount logic
- Proper decimal precision
- Uses Sequelize (project ORM)
- Follows project patterns
```

### Example 3: Review with Skills
```
Prompt: "Review this checkout function using the 
         code-reviewer and ecommerce-validator skills"

Result: Claude provides:
- General code quality feedback (code-reviewer)
- E-commerce business rule validation (ecommerce-validator)
- Specific, actionable suggestions
```

## 📚 Step 3: See a Complete Example (2 min)

### The Task
"Implement product review endpoint"

### The Prompt
```
Using the ecommerce-backend-developer agent, implement a POST endpoint 
that allows users to review products. Users must have purchased the 
product to leave a review. Rating should be 1-5 stars.
```

### What Happens Behind the Scenes
1. Loads `senior-developer` (base agent)
2. Loads `ecommerce-backend-developer` (extends base)
3. Loads skills: `code-reviewer`, `test-generator`, `ecommerce-validator`
4. Understands: Node.js, Express, Sequelize, PostgreSQL
5. Knows: E-commerce business rules

### What You Get
```javascript
// Complete implementation with:
✓ Authentication required
✓ Checks if user purchased product
✓ Validates rating (1-5)
✓ Prevents duplicate reviews
✓ Uses Sequelize models (project pattern)
✓ Proper error handling
✓ Follows project response format
✓ Comprehensive comments
```

## 🎯 Step 4: Where to Go Next

### Want to See More?
→ Read [INTERACTIVE_DEMO.md](INTERACTIVE_DEMO.md)
   - Complete walkthrough with multiple approaches
   - Shows the difference with/without agents
   - Includes code reviews and testing

### Want to Create Your Own?
→ Read [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
   - Step-by-step guide to creating agents/skills
   - Templates and examples
   - Real-world patterns
   - Testing strategies

### Want to Understand the Structure?
→ Read [.github/README.md](.github/README.md)
   - Global configurations explained
   - When to use what

→ Read [.claude/README.md](.claude/README.md)
   - Project configurations explained
   - How to customize for your domain

## 💡 Key Concepts to Remember

### 1. Global vs Project
```
Global (.github/):    Reusable across all projects
Project (.claude/):   Specific to this project
```

### 2. Agent = Persona
```
senior-developer:              General coding
ecommerce-backend-developer:   E-commerce coding
```

### 3. Skills = Tools
```
code-reviewer:       General quality
ecommerce-validator: Business rules
```

### 4. Composition
```
Project Agent = Global Agent + Domain Context + Project Skills
```

## 🔥 Power Tips

### Tip 1: Be Specific
```
❌ "Create a checkout function"
✅ "Using the ecommerce-backend-developer agent, 
   create a checkout function"
```

### Tip 2: Combine Skills
```
"Review using code-reviewer and ecommerce-validator skills"
→ Gets both general AND domain-specific feedback
```

### Tip 3: Reference Context
```
"Following the patterns in .claude/agents/ecommerce-backend-developer.md,
implement payment processing"
```

### Tip 4: Iterate
```
1. Generate code with agent
2. Review with skills
3. Refine based on feedback
4. Document with documentation-specialist agent
```

## ✅ Quick Reference

### For Implementing Features
```yaml
agent: ecommerce-backend-developer
# or: senior-developer (for non-e-commerce)
```

### For Documentation
```yaml
agent: api-documentation-agent
# or: documentation-specialist (for general docs)
```

### For Code Review
```yaml
skills:
  - code-reviewer
  - ecommerce-validator  # if e-commerce code
```

### For Testing
```yaml
skills:
  - test-generator
```

### For Database Changes
```yaml
skills:
  - database-migration
```

## 🎮 Try These Now

Copy-paste these prompts to see it in action:

### Prompt 1: Implementation
```
Using the ecommerce-backend-developer agent, implement a GET endpoint 
that returns a list of products with filters for category and price range. 
Include pagination.
```

### Prompt 2: Review
```
Review the following code using the code-reviewer and ecommerce-validator skills:
[paste your code]
```

### Prompt 3: Testing
```
Using the test-generator skill, create comprehensive tests for this 
product listing endpoint:
[paste your endpoint code]
```

### Prompt 4: Documentation
```
Using the api-documentation-agent, document this endpoint in OpenAPI format:
[paste your endpoint code]
```

## 🎯 Success Indicators

You're using agents/skills effectively when:

- ✅ Generated code follows your project patterns
- ✅ Business rules are automatically applied
- ✅ Less back-and-forth corrections needed
- ✅ Consistent code quality
- ✅ Fewer mistakes in domain logic

## 🚀 Next Steps

1. ✅ You've completed the quick start!
2. → Try the example prompts above
3. → Read [INTERACTIVE_DEMO.md](INTERACTIVE_DEMO.md) for deep dive
4. → Read [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) to create your own

## 📞 Need Help?

- Check the documentation in each folder
- Review examples in agent/skill files
- Open an issue with questions

**Congratulations! You now understand the basics of Claude agents and skills! 🎉**
