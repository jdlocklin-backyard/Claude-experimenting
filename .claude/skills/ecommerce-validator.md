# E-Commerce Validator Skill

## Purpose
This is a PROJECT-SPECIFIC skill for validating e-commerce business logic, pricing, and inventory rules.

## Skill Definition
**Skill Name:** ecommerce-validator  
**Type:** Business Logic Validation  
**Scope:** Project (Specific to e-commerce projects)

## Capabilities
- **Price Validation**: Verify pricing logic, discounts, and promotions
- **Inventory Checks**: Validate stock levels and availability logic
- **Cart Logic**: Ensure shopping cart calculations are correct
- **Order Validation**: Verify order processing rules
- **Tax Calculations**: Check tax computation accuracy

## Usage Pattern
This skill validates e-commerce-specific business rules that go beyond general code review:
1. Validate that prices are always positive and properly formatted
2. Check that discount logic doesn't create negative prices
3. Ensure inventory decrements happen atomically
4. Verify that tax calculations match business requirements
5. Confirm payment flows follow security best practices

## Example Invocation
```yaml
# In project-specific agent:
skills:
  - code-reviewer          # Global skill
  - ecommerce-validator    # Project skill

task: "Review the checkout flow implementation"
context:
  - file: "src/checkout/cart.js"
  - focus: "pricing and inventory validation"
```

## Best Practices for This Skill
- **Currency Precision**: Always use decimal/numeric types for money, never floats
- **Atomic Operations**: Inventory updates must be transactional
- **Rounding Rules**: Apply consistent rounding (e.g., always round to 2 decimals)
- **Discount Stacking**: Define clear rules for applying multiple discounts
- **Tax Jurisdiction**: Ensure tax calculations respect user location

## Interactive Example

**Code to Validate:**
```javascript
function applyDiscount(price, discountPercent) {
  return price - (price * discountPercent / 100);
}

function calculateTotal(items) {
  let total = 0;
  for (let item of items) {
    total += item.price * item.quantity;
  }
  return total;
}
```

**Skill Validation Output:**
```json
{
  "findings": [
    {
      "severity": "high",
      "function": "applyDiscount",
      "issue": "Price precision not maintained",
      "line": 2,
      "explanation": "Result should be rounded to 2 decimal places for currency",
      "suggestion": "return Math.round((price - (price * discountPercent / 100)) * 100) / 100;"
    },
    {
      "severity": "medium",
      "function": "applyDiscount",
      "issue": "No validation for negative final price",
      "line": 2,
      "explanation": "Discount could exceed 100% resulting in negative price",
      "suggestion": "Add: if (discountPercent > 100) throw new Error('Invalid discount');"
    },
    {
      "severity": "high",
      "function": "calculateTotal",
      "issue": "No inventory validation",
      "line": 4,
      "explanation": "Should check if item.quantity doesn't exceed available stock",
      "suggestion": "Add inventory check before calculation"
    },
    {
      "severity": "low",
      "function": "calculateTotal",
      "issue": "Missing tax calculation",
      "line": 6,
      "explanation": "Total should include applicable taxes based on customer location",
      "suggestion": "return calculateTax(total, customer.location);"
    }
  ],
  "businessRuleChecks": {
    "priceValidation": "⚠ Needs improvement",
    "inventoryValidation": "❌ Missing",
    "taxCalculation": "❌ Missing",
    "discountRules": "⚠ Partial"
  }
}
```

## Business Rules Checklist
When validating e-commerce code, check:
- [ ] Prices are stored as integers (cents) or precise decimals
- [ ] All monetary calculations maintain precision
- [ ] Discounts cannot result in negative prices
- [ ] Inventory is checked before allowing purchase
- [ ] Stock decrements are atomic (use database transactions)
- [ ] Tax is calculated based on current rates and jurisdiction
- [ ] Shipping costs are properly added
- [ ] Total calculation includes all applicable fees
- [ ] Payment amount matches calculated total
- [ ] Currency conversions use current exchange rates

## Configuration Options
```json
{
  "currency": "USD",
  "precision": 2,
  "taxRules": {
    "enabled": true,
    "calculateByLocation": true
  },
  "inventoryChecks": {
    "enforceStockLimits": true,
    "allowBackorders": false
  },
  "discountRules": {
    "maxPercentage": 100,
    "allowStacking": false,
    "requireCouponCode": true
  }
}
```

## How Models Use This Skill
When Claude works on e-commerce code with this skill active:
1. **Context Loading**: Claude loads both global code-reviewer AND this project-specific skill
2. **Dual Validation**: Code is checked for general quality AND e-commerce business rules
3. **Business Logic Awareness**: Claude considers e-commerce best practices automatically
4. **Domain-Specific Suggestions**: Recommendations are tailored to e-commerce context
5. **Compliance**: Ensures code meets business and regulatory requirements

## Integration with Global Skills
This skill EXTENDS the global `code-reviewer` skill:
```
Global code-reviewer provides:
  - General code quality
  - Security patterns
  - Performance optimization

Project ecommerce-validator adds:
  - Business rule validation
  - Domain-specific checks
  - Industry best practices
```

**Note:** This is a **PROJECT-SPECIFIC skill** - it supplements global skills with domain knowledge specific to e-commerce applications.
