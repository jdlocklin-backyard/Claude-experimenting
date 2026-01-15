# 🎮 Interactive Demo: Agents and Skills in Action

This is a **step-by-step walkthrough** showing how agents and skills work together. Follow along to see the system in action!

## 🎯 Scenario: Building a Product Review Feature

Let's walk through implementing a new feature for our e-commerce platform: **Product Reviews**

---

## 📚 Phase 1: Understanding the Setup

### What We Have
```
Global Configs (.github/):
├── agents/senior-developer.md           # General coding agent
├── agents/documentation-specialist.md   # Documentation agent
├── skills/code-reviewer.md              # Code quality checking
└── skills/test-generator.md             # Test creation

Project Configs (.claude/):
├── agents/ecommerce-backend-developer.md    # E-commerce specialist
├── agents/api-documentation-agent.md        # API doc specialist
├── skills/ecommerce-validator.md            # Business logic validation
└── skills/database-migration.md             # Database changes
```

---

## 🚀 Phase 2: Implementation Task

### Task: "Add product review endpoint to the API"

Let's see how different approaches work:

---

### ❌ Approach 1: No Agent Context

**Prompt:** "Create an API endpoint for product reviews"

**What Claude Would Do:**
```javascript
// Generic implementation without context
app.post('/reviews', (req, res) => {
  const review = req.body;
  // Store review somehow
  res.json({ success: true });
});
```

**Problems:**
- No authentication check
- No input validation
- Doesn't follow project patterns
- No business logic
- No error handling

---

### ⚠️ Approach 2: With Global Agent Only

**Prompt:** "Using the senior-developer agent, create an API endpoint for product reviews"

**What Happens:**
1. ✅ Claude loads `senior-developer` agent
2. ✅ Loads `code-reviewer` skill
3. ✅ Loads `test-generator` skill
4. ⚠️ No project context about e-commerce
5. ⚠️ No knowledge of tech stack (Sequelize, etc.)

**Claude's Output:**
```javascript
// Better, but still generic
const express = require('express');

// Uses generic patterns, not project patterns
const createReview = async (req, res) => {
  try {
    const { productId, rating, comment } = req.body;
    
    // Generic validation
    if (!productId || !rating) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    // Generic database call (doesn't know we use Sequelize)
    const review = await database.insert('reviews', {
      productId,
      rating,
      comment
    });
    
    return res.status(201).json(review);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
```

**Better, but:**
- Uses `database.insert` instead of Sequelize models
- Missing business rules (rating range 1-5)
- No verification that product exists
- No check if user purchased product
- Doesn't follow project response format

---

### ✅ Approach 3: With Project-Specific Agent

**Prompt:** "Using the ecommerce-backend-developer agent, create an API endpoint for product reviews"

**What Happens:**
1. ✅ Claude loads `senior-developer` agent (base)
2. ✅ Claude loads `ecommerce-backend-developer` (extends base)
3. ✅ Loads skills: code-reviewer, test-generator
4. ✅ Loads project skills: ecommerce-validator, database-migration
5. ✅ Knows tech stack: Node.js, Express, Sequelize, PostgreSQL
6. ✅ Understands e-commerce patterns and business rules

**Claude's Output:**
```javascript
/**
 * Product Review Endpoint
 * 
 * Allows customers to review products they have purchased.
 * 
 * Business Rules:
 * - User must be authenticated
 * - User must have purchased the product
 * - Rating must be 1-5
 * - Only one review per user per product
 * - Review can be updated within 30 days
 */

const { Review, Order, OrderItem, Product } = require('../models');
const { authenticateUser } = require('../middleware/auth');

const createReview = async (req, res) => {
  try {
    const { productId, rating, comment } = req.body;
    const userId = req.user.id;  // From auth middleware
    
    // Input validation
    if (!productId || !rating) {
      return res.status(400).json({ 
        error: 'Missing required fields',
        required: ['productId', 'rating']
      });
    }
    
    // Validate rating range (e-commerce business rule)
    if (rating < 1 || rating > 5) {
      return res.status(400).json({
        error: 'Invalid rating',
        message: 'Rating must be between 1 and 5'
      });
    }
    
    // Verify product exists
    const product = await Product.findByPk(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    
    // Business rule: User must have purchased the product
    const hasPurchased = await OrderItem.findOne({
      include: [{
        model: Order,
        where: { 
          userId,
          status: 'delivered'  // Only delivered orders count
        }
      }],
      where: { productId }
    });
    
    if (!hasPurchased) {
      return res.status(403).json({
        error: 'Cannot review',
        message: 'You can only review products you have purchased'
      });
    }
    
    // Check for existing review
    const existingReview = await Review.findOne({
      where: { userId, productId }
    });
    
    if (existingReview) {
      return res.status(409).json({
        error: 'Review already exists',
        message: 'You have already reviewed this product',
        reviewId: existingReview.id
      });
    }
    
    // Create review (using Sequelize model from project)
    const review = await Review.create({
      userId,
      productId,
      rating,
      comment: comment || null,
      verified: true  // Verified purchase
    });
    
    // Update product average rating (business logic)
    await product.updateAverageRating();
    
    // Return in project's standard format
    return res.status(201).json({
      review: {
        id: review.id,
        productId: review.productId,
        rating: review.rating,
        comment: review.comment,
        verified: review.verified,
        createdAt: review.createdAt
      }
    });
    
  } catch (error) {
    console.error('Create review error:', error);
    return res.status(500).json({ 
      error: 'Failed to create review',
      message: 'An error occurred while creating your review'
    });
  }
};

// Apply authentication middleware
router.post('/reviews', authenticateUser, createReview);

module.exports = { createReview };
```

**✨ Notice the Difference:**
- ✅ Uses Sequelize models (Project pattern)
- ✅ Validates rating is 1-5 (E-commerce rule)
- ✅ Checks if user purchased product (Business logic)
- ✅ Prevents duplicate reviews (Business logic)
- ✅ Updates product rating average (Domain knowledge)
- ✅ Uses auth middleware (Project convention)
- ✅ Follows project response format (Consistency)
- ✅ Includes comprehensive error handling

---

## 🔍 Phase 3: Code Review with Skills

Now let's see how skills work when reviewing this code.

### Using Code-Reviewer Skill (Global)

**Prompt:** "Review this code using the code-reviewer skill"

**Output from code-reviewer skill:**
```json
{
  "findings": [
    {
      "severity": "low",
      "issue": "Error messages expose system details",
      "location": "line 82",
      "suggestion": "Don't log error details to client in production"
    }
  ],
  "generalAssessment": {
    "codeQuality": "✅ Excellent",
    "security": "✅ Good - uses authentication, validates input",
    "performance": "✅ Good - uses database indexes",
    "documentation": "✅ Excellent - well commented"
  }
}
```

### Using E-Commerce Validator Skill (Project)

**Prompt:** "Also validate using the ecommerce-validator skill"

**Output from ecommerce-validator skill:**
```json
{
  "businessRuleChecks": {
    "authentication": "✅ PASS - Requires authentication",
    "authorization": "✅ PASS - Verifies purchase before review",
    "dataIntegrity": "✅ PASS - Prevents duplicate reviews",
    "businessLogic": "✅ PASS - Rating validation (1-5)",
    "audit": "✅ PASS - Tracks verified purchases"
  },
  "domainSpecificFindings": [
    {
      "severity": "medium",
      "issue": "No review moderation",
      "suggestion": "Consider adding profanity filter or manual approval for new users"
    },
    {
      "severity": "low", 
      "issue": "No rate limiting",
      "suggestion": "Prevent review spam by adding rate limits"
    }
  ],
  "ecommerceCompliance": "✅ Meets e-commerce best practices"
}
```

**Combined Result:** Code passes both general quality AND business logic checks!

---

## 📝 Phase 4: Generating Tests

**Prompt:** "Using the test-generator skill, create tests for this endpoint"

**Generated Tests:**
```javascript
describe('POST /reviews', () => {
  // Setup
  let authToken, userId, productId, orderId;
  
  beforeEach(async () => {
    // Create test user
    const user = await User.create({
      email: 'test@example.com',
      password: 'hashedpassword'
    });
    userId = user.id;
    authToken = generateToken(user);
    
    // Create test product
    const product = await Product.create({
      name: 'Test Product',
      price: 99.99,
      stock: 10
    });
    productId = product.id;
    
    // Create test order (delivered)
    const order = await Order.create({
      userId,
      status: 'delivered'
    });
    orderId = order.id;
    
    await OrderItem.create({
      orderId,
      productId,
      quantity: 1
    });
  });
  
  // Happy path - successful review
  test('creates review for purchased product', async () => {
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId,
        rating: 5,
        comment: 'Great product!'
      });
    
    expect(response.status).toBe(201);
    expect(response.body.review).toMatchObject({
      productId,
      rating: 5,
      verified: true
    });
  });
  
  // Error case - not authenticated
  test('rejects unauthenticated requests', async () => {
    const response = await request(app)
      .post('/reviews')
      .send({ productId, rating: 5 });
    
    expect(response.status).toBe(401);
  });
  
  // Business rule - must have purchased
  test('rejects review if user has not purchased product', async () => {
    const otherProduct = await Product.create({
      name: 'Other Product',
      price: 49.99
    });
    
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId: otherProduct.id,
        rating: 5
      });
    
    expect(response.status).toBe(403);
    expect(response.body.error).toBe('Cannot review');
  });
  
  // Validation - rating range
  test('rejects invalid rating (too high)', async () => {
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId,
        rating: 6  // Invalid
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error).toBe('Invalid rating');
  });
  
  test('rejects invalid rating (too low)', async () => {
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId,
        rating: 0  // Invalid
      });
    
    expect(response.status).toBe(400);
  });
  
  // Business rule - no duplicates
  test('prevents duplicate reviews', async () => {
    // Create first review
    await Review.create({
      userId,
      productId,
      rating: 5
    });
    
    // Try to create duplicate
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId,
        rating: 4
      });
    
    expect(response.status).toBe(409);
    expect(response.body.error).toBe('Review already exists');
  });
  
  // Edge case - no comment
  test('allows review without comment', async () => {
    const response = await request(app)
      .post('/reviews')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        productId,
        rating: 5
        // no comment
      });
    
    expect(response.status).toBe(201);
    expect(response.body.review.comment).toBeNull();
  });
});
```

**Notice:** Tests cover happy path, error cases, edge cases, AND business rules!

---

## 📖 Phase 5: Documentation

**Prompt:** "Using the api-documentation-agent, document this endpoint"

**Generated Documentation:**

See the agent file `.claude/agents/api-documentation-agent.md` for the full documentation format! It would include:
- OpenAPI specification
- Request/response examples in multiple languages
- Error code documentation
- Business rule explanations

---

## 🎓 Key Learnings

### 1. Agent Hierarchy Works
```
Global Agent (foundation)
    ↓
Project Agent (specialization)
    ↓
Domain-Aware Implementation
```

### 2. Skills Compose
```
General Skills (code-reviewer, test-generator)
    +
Domain Skills (ecommerce-validator)
    =
Comprehensive Validation
```

### 3. Context Matters
- **No context** → Generic code
- **Global context** → Better code
- **Project context** → Perfect code

### 4. Examples Guide Output
The patterns and examples in agent/skill files directly influence how Claude responds.

---

## 🎮 Try It Yourself!

### Exercise 1: Add Update Review
**Task:** "Using the ecommerce-backend-developer agent, add an endpoint to update a review"

**What to expect:**
- Should check review ownership
- Should enforce 30-day update window
- Should use Sequelize update methods
- Should follow project patterns

### Exercise 2: Add Review Reporting
**Task:** "Using the ecommerce-backend-developer agent, add ability to report inappropriate reviews"

**What to expect:**
- Should require authentication
- Should prevent duplicate reports
- Should add to moderation queue
- Should follow business rules

---

## 💡 Pro Tips

1. **Always specify the agent** - Don't leave it to chance
2. **Reference relevant skills** - They enhance the agent
3. **Provide context** - The more specific, the better
4. **Review the output** - Make sure it follows patterns
5. **Iterate** - Refine agents/skills based on results

---

## 📊 Impact Summary

| Without Agents/Skills | With Agents/Skills |
|---------------------|-------------------|
| Generic implementations | Domain-specific code |
| Missing business rules | Business rules enforced |
| Inconsistent patterns | Project conventions followed |
| Need many corrections | Mostly correct first time |
| Manual validation needed | Automatic validation |

---

## 🎯 Next Steps

1. ✅ You've seen how it works
2. → Read `IMPLEMENTATION_GUIDE.md` to create your own
3. → Adapt the examples for your projects
4. → Start small, iterate, and expand

**Happy coding! 🚀**
