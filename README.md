# 🎯 Claude Agent & Skills Scaffolding

**Take the guesswork out of using Claude for development!**

This repository provides a complete, production-ready framework for configuring Claude with **agents** (personas) and **skills** (capabilities). Learn by example with our interactive e-commerce demo.

## 🚀 Quick Start

1. **Explore the structure** - See how global and project configs work together
2. **Try the demo** - Follow `INTERACTIVE_DEMO.md` for a complete walkthrough
3. **Create your own** - Use `IMPLEMENTATION_GUIDE.md` as your blueprint

## 📁 What's Inside

```
.github/                    # 🌍 GLOBAL: Reusable across all projects
├── agents/                 # Agent personas (senior-developer, documentation-specialist)
├── skills/                 # Capabilities (code-reviewer, test-generator)
└── README.md              # Global configuration guide

.claude/                    # 🎯 PROJECT: E-commerce specific
├── agents/                 # Domain agents (ecommerce-backend-developer, api-doc-agent)
├── skills/                 # Domain skills (ecommerce-validator, database-migration)
└── README.md              # Project configuration guide

📚 Documentation
├── INTERACTIVE_DEMO.md         # Step-by-step walkthrough
├── IMPLEMENTATION_GUIDE.md     # How to create your own
└── QUICK_START.md              # Get started in 5 minutes
```

## 🎭 What Are Agents?

**Agents** are personas Claude adopts for tasks. They define:
- Role and responsibilities
- Decision-making approach
- Available skills
- Output patterns

**Example:**
```yaml
agent: ecommerce-backend-developer
task: "Implement checkout endpoint"
# Claude loads agent context and generates e-commerce-aware code
```

## 🛠️ What Are Skills?

**Skills** are specific capabilities agents can use:
- Code review
- Test generation
- Business logic validation
- Domain-specific checks

**Example:**
```yaml
skills:
  - code-reviewer        # Global: general quality
  - ecommerce-validator  # Project: business rules
# Claude applies both general and domain-specific validation
```

## 🎯 Why Use This?

### ❌ Without Agent/Skill Configuration
```javascript
// Generic code without context
app.post('/checkout', (req, res) => {
  // Missing auth, validation, business logic
  const order = req.body;
  res.json({ success: true });
});
```

### ✅ With Agent/Skill Configuration
```javascript
// Domain-aware, follows project patterns
const checkout = async (req, res) => {
  // ✓ Uses project patterns (Sequelize)
  // ✓ Includes authentication
  // ✓ Validates inventory
  // ✓ Calculates prices server-side
  // ✓ Uses transactions
  // ✓ Follows business rules
  // ✓ Comprehensive error handling
};
```

## 🌟 Key Features

- ✅ **Complete Examples** - Real agents and skills, not templates
- ✅ **Interactive Demo** - Follow along with working code
- ✅ **Best Practices** - Industry-proven patterns
- ✅ **Copy-Paste Ready** - Use immediately or customize
- ✅ **Well Documented** - Inline notes explain everything
- ✅ **Composable** - Mix global and project configs
- ✅ **Battle Tested** - Based on real-world usage

## 📖 Documentation

| Document | Purpose | Read Time |
|----------|---------|-----------|
| `QUICK_START.md` | Get up and running | 5 min |
| `INTERACTIVE_DEMO.md` | See it in action | 15 min |
| `IMPLEMENTATION_GUIDE.md` | Create your own | 30 min |
| `.github/README.md` | Global configs explained | 10 min |
| `.claude/README.md` | Project configs explained | 10 min |

## 🎮 Try It Now

### 1. Basic Usage
```
"Using the senior-developer agent, implement user authentication"
```

### 2. Project-Specific
```
"Using the ecommerce-backend-developer agent, implement product reviews"
```

### 3. With Skills
```
"Review this code using code-reviewer and ecommerce-validator skills"
```

## 💡 Use Cases

### For Individual Developers
- Get consistent, high-quality code
- Follow best practices automatically
- Reduce back-and-forth corrections

### For Teams
- Enforce coding standards
- Share domain knowledge
- Onboard new members faster

### For Projects
- Maintain consistency
- Apply business rules automatically
- Meet compliance requirements

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│     Global Configurations           │
│         (.github/)                  │
│                                     │
│  General-purpose agents & skills    │
│  Reusable across all projects       │
└──────────────┬──────────────────────┘
               │ extends
               ↓
┌─────────────────────────────────────┐
│   Project Configurations            │
│         (.claude/)                  │
│                                     │
│  Domain-specific agents & skills    │
│  Customized for this project        │
└──────────────┬──────────────────────┘
               │ loads
               ↓
┌─────────────────────────────────────┐
│          Claude                     │
│                                     │
│  Uses combined context to generate  │
│  domain-aware, project-specific     │
│  code following best practices      │
└─────────────────────────────────────┘
```

## 🔥 Real-World Examples

### E-Commerce (Included)
- Checkout flows with payment processing
- Inventory management
- Price calculations
- Order processing

### Healthcare (Implementation Guide)
- HIPAA-compliant data handling
- PHI protection
- Audit logging
- Access controls

### Your Project? (Coming Soon!)
Follow `IMPLEMENTATION_GUIDE.md` to create configurations for:
- Your domain (fintech, edtech, social media, etc.)
- Your tech stack
- Your business rules
- Your team conventions

## 🤝 Contributing

Contributions welcome! Consider adding:
- More example domains
- Additional global agents/skills
- Real-world case studies
- Documentation improvements

## 📝 License

MIT - Use freely in your projects!

## 🎓 Learn More

- **Start Here:** [QUICK_START.md](QUICK_START.md)
- **Deep Dive:** [INTERACTIVE_DEMO.md](INTERACTIVE_DEMO.md)
- **Build Your Own:** [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)

## 🌟 Star This Repo

If you find this useful, please star the repo to help others discover it!

## 📞 Questions?

Open an issue or check the documentation. Happy coding! 🚀 
