# Test Generator Skill

## Purpose
This skill enables agents to automatically generate comprehensive test cases for code, ensuring proper test coverage and quality.

## Skill Definition
**Skill Name:** test-generator  
**Type:** Code Generation  
**Scope:** Global (Available across all projects)

## Capabilities
- **Unit Test Generation**: Create unit tests for functions and methods
- **Integration Test Creation**: Generate tests for component interactions
- **Edge Case Identification**: Automatically identify and test edge cases
- **Mock Generation**: Create mocks and stubs for dependencies
- **Test Data Creation**: Generate realistic test data

## Usage Pattern
When invoked, this skill should:
1. Analyze the target code structure
2. Identify testable units and their dependencies
3. Generate appropriate test cases with assertions
4. Follow the project's testing framework conventions

## Example Invocation
```yaml
# In an agent configuration:
skills:
  - test-generator

# Task example:
task: "Generate unit tests for the user service module"
context:
  - file: "src/services/userService.js"
  - framework: "jest"
  - coverage_target: "90%"
```

## Best Practices for This Skill
- **Follow conventions**: Match the existing test style in the project
- **Be comprehensive**: Cover happy paths, error cases, and edge cases
- **Keep tests independent**: Each test should run in isolation
- **Use meaningful names**: Test names should clearly describe what they test
- **Assert specifically**: Make precise assertions, not vague ones

## Interactive Example
```javascript
// SOURCE CODE:
function calculateDiscount(price, customerType) {
  if (price < 0) throw new Error('Invalid price');
  if (customerType === 'premium') return price * 0.8;
  if (customerType === 'regular') return price * 0.95;
  return price;
}

// GENERATED TESTS:
describe('calculateDiscount', () => {
  // Happy path - premium customer
  test('applies 20% discount for premium customers', () => {
    expect(calculateDiscount(100, 'premium')).toBe(80);
  });
  
  // Happy path - regular customer
  test('applies 5% discount for regular customers', () => {
    expect(calculateDiscount(100, 'regular')).toBe(95);
  });
  
  // Edge case - no discount
  test('applies no discount for other customer types', () => {
    expect(calculateDiscount(100, 'guest')).toBe(100);
  });
  
  // Error case - negative price
  test('throws error for negative price', () => {
    expect(() => calculateDiscount(-10, 'premium')).toThrow('Invalid price');
  });
  
  // Edge case - zero price
  test('handles zero price correctly', () => {
    expect(calculateDiscount(0, 'premium')).toBe(0);
  });
});
```

## Configuration Options
```json
{
  "framework": "jest",  // jest, mocha, pytest, junit, etc.
  "style": "BDD",       // BDD, TDD, AAA (Arrange-Act-Assert)
  "coverage": {
    "minimum": 80,
    "target": 90
  },
  "includes": {
    "unit": true,
    "integration": true,
    "e2e": false
  }
}
```

## How Models Use This Skill
When Claude needs to generate tests:
1. Agent configuration references `skills: [test-generator]`
2. Claude loads this skill as context to understand test generation patterns
3. The examples guide the structure and comprehensiveness of tests
4. Configuration options adapt behavior to project needs
5. Best practices ensure generated tests are maintainable

**Note:** This is a **global skill** - available to any agent that needs test generation capabilities.
