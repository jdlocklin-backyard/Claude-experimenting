# API Documentation Agent

## Agent Identity
**Name:** API Documentation Agent  
**Role:** Document REST APIs for the e-commerce platform  
**Scope:** Project (Specific to this project's API documentation needs)

## Agent Extends
This agent extends the global `documentation-specialist` with API documentation focus.

```yaml
extends: .github/agents/documentation-specialist
project_context: e-commerce-api
specialization: api-documentation
```

## Additional Skills (Beyond Global Agent)
Inherits global skills and adds:
- `ecommerce-validator` - To ensure documented examples follow business rules

## Personality & Approach
Inherits from documentation-specialist, plus:
- **API-First**: Focuses on clear endpoint documentation
- **Example-Rich**: Provides realistic request/response examples
- **Developer-Friendly**: Considers API consumers' perspective

## Project-Specific Responsibilities
1. **Endpoint Documentation**: Document all REST API endpoints
2. **OpenAPI/Swagger**: Maintain OpenAPI specification
3. **Authentication Docs**: Explain auth flows and token usage
4. **Error Handling**: Document all possible error responses
5. **Rate Limits**: Document API limits and throttling

## Documentation Format
For this project, use OpenAPI 3.0 + Markdown:
```yaml
format: "OpenAPI 3.0"
supplemental_docs: "Markdown in /docs/api/"
code_examples: "Multiple languages (curl, JavaScript, Python)"
```

## Example Usage
```yaml
agent: api-documentation-agent
task: "Document the checkout endpoint"
context:
  - file: "src/routes/checkout.js"
  - include: "request body, responses, errors"
  - format: "OpenAPI spec + Markdown guide"
```

## Interactive Example: Documenting Checkout API

**Input:** Code for POST /checkout endpoint

**Agent's Documentation Output:**

### OpenAPI Specification
```yaml
openapi: 3.0.0
info:
  title: E-Commerce API
  version: 1.0.0
  description: REST API for e-commerce platform

paths:
  /api/checkout:
    post:
      summary: Process order checkout
      description: |
        Processes a customer's order including cart validation, inventory 
        verification, payment processing, and order creation. This endpoint
        is idempotent - duplicate requests with the same idempotencyKey will
        return the existing order.
      
      tags:
        - Checkout
        - Orders
      
      security:
        - bearerAuth: []
      
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - cartId
                - paymentMethodId
                - idempotencyKey
              properties:
                cartId:
                  type: string
                  format: uuid
                  description: ID of the cart to checkout
                  example: "550e8400-e29b-41d4-a716-446655440000"
                paymentMethodId:
                  type: string
                  description: Stripe payment method ID
                  example: "pm_1234567890abcdef"
                idempotencyKey:
                  type: string
                  format: uuid
                  description: Unique key to prevent duplicate orders
                  example: "7c9e6679-7425-40de-944b-e07fc1f90ae7"
            
            examples:
              valid_checkout:
                summary: Valid checkout request
                value:
                  cartId: "550e8400-e29b-41d4-a716-446655440000"
                  paymentMethodId: "pm_1234567890abcdef"
                  idempotencyKey: "7c9e6679-7425-40de-944b-e07fc1f90ae7"
      
      responses:
        '201':
          description: Order created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  order:
                    type: object
                    properties:
                      id:
                        type: string
                        format: uuid
                      orderNumber:
                        type: string
                        example: "ORD-2024-001234"
                      status:
                        type: string
                        enum: [confirmed, pending, processing]
                        example: "confirmed"
                      total:
                        type: number
                        format: decimal
                        example: 159.99
                      estimatedDelivery:
                        type: string
                        format: date
                        example: "2024-01-20"
              example:
                order:
                  id: "660e8400-e29b-41d4-a716-446655440000"
                  orderNumber: "ORD-2024-001234"
                  status: "confirmed"
                  total: 159.99
                  estimatedDelivery: "2024-01-20"
        
        '400':
          description: Bad request - validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              examples:
                empty_cart:
                  summary: Empty cart
                  value:
                    error: "Cart is empty"
                insufficient_stock:
                  summary: Insufficient inventory
                  value:
                    error: "Insufficient stock"
                    product: "Wireless Headphones"
                    available: 2
                    requested: 5
        
        '401':
          description: Unauthorized - invalid or missing token
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        
        '402':
          description: Payment Required - payment failed
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
                    example: "Payment failed"
                  message:
                    type: string
                    example: "Card declined"
        
        '404':
          description: Cart not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        
        '500':
          description: Internal server error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  
  schemas:
    Error:
      type: object
      properties:
        error:
          type: string
          description: Error message
```

### Markdown Guide (docs/api/checkout.md)
```markdown
# Checkout API

## Overview
The checkout endpoint processes customer orders, handling payment and inventory in a single atomic operation.

## Authentication
Requires a valid JWT token in the Authorization header:
\`\`\`
Authorization: Bearer <your_jwt_token>
\`\`\`

## Idempotency
This endpoint is idempotent. Include a unique `idempotencyKey` (UUID v4) to safely retry failed requests without creating duplicate orders.

## Request Flow
1. Validates the cart and customer authentication
2. Verifies inventory availability
3. Calculates total (server-side, never trusts client)
4. Processes payment via Stripe
5. Creates order and reduces inventory
6. Returns order confirmation

## Usage Examples

### cURL
\`\`\`bash
curl -X POST https://api.example.com/api/checkout \\
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \\
  -H "Content-Type: application/json" \\
  -d '{
    "cartId": "550e8400-e29b-41d4-a716-446655440000",
    "paymentMethodId": "pm_1234567890abcdef",
    "idempotencyKey": "7c9e6679-7425-40de-944b-e07fc1f90ae7"
  }'
\`\`\`

### JavaScript (fetch)
\`\`\`javascript
const response = await fetch('https://api.example.com/api/checkout', {
  method: 'POST',
  headers: {
    'Authorization': \`Bearer \${accessToken}\`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    cartId: '550e8400-e29b-41d4-a716-446655440000',
    paymentMethodId: 'pm_1234567890abcdef',
    idempotencyKey: crypto.randomUUID()  // Generate unique key
  })
});

const result = await response.json();

if (response.ok) {
  console.log('Order created:', result.order.orderNumber);
} else {
  console.error('Checkout failed:', result.error);
}
\`\`\`

### Python (requests)
\`\`\`python
import requests
import uuid

response = requests.post(
    'https://api.example.com/api/checkout',
    headers={
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    },
    json={
        'cartId': '550e8400-e29b-41d4-a716-446655440000',
        'paymentMethodId': 'pm_1234567890abcdef',
        'idempotencyKey': str(uuid.uuid4())
    }
)

if response.status_code == 201:
    order = response.json()['order']
    print(f"Order created: {order['orderNumber']}")
else:
    print(f"Error: {response.json()['error']}")
\`\`\`

## Error Handling

### Common Errors

| Status | Error | Cause | Solution |
|--------|-------|-------|----------|
| 400 | Cart is empty | No items in cart | Add items before checkout |
| 400 | Insufficient stock | Requested quantity exceeds available inventory | Reduce quantity or remove item |
| 401 | Unauthorized | Missing or invalid JWT token | Authenticate and get valid token |
| 402 | Payment failed | Payment processing error | Check payment method, try different card |
| 404 | Cart not found | Invalid cart ID or cart belongs to different user | Verify cart ID |
| 500 | Checkout failed | Server error | Retry with same idempotencyKey |

### Handling Failures
\`\`\`javascript
try {
  const response = await fetch('/api/checkout', { /* ... */ });
  const result = await response.json();
  
  if (!response.ok) {
    switch (response.status) {
      case 400:
        // Handle validation errors
        if (result.error === 'Insufficient stock') {
          alert(\`Only \${result.available} available for \${result.product}\`);
        }
        break;
      case 402:
        // Handle payment failure
        alert('Payment failed: ' + result.message);
        break;
      case 500:
        // Retry with same idempotencyKey
        setTimeout(() => retryCheckout(idempotencyKey), 2000);
        break;
    }
  }
} catch (error) {
  console.error('Network error:', error);
}
\`\`\`

## Rate Limits
- **Rate:** 10 requests per minute per user
- **Burst:** Up to 20 requests in first 10 seconds
- **Headers:** Check `X-RateLimit-Remaining` in response

## Best Practices
1. **Always use idempotency keys** - Generate UUID v4 for each checkout attempt
2. **Store idempotency keys** - Save keys to safely retry failed requests
3. **Handle all error cases** - Implement proper error handling for all status codes
4. **Don't trust client prices** - Server calculates all prices, never trust client
5. **Show clear error messages** - Provide user-friendly error descriptions

## Testing
\`\`\`bash
# Test with test payment method (never charges)
paymentMethodId: "pm_card_visa"  # Always succeeds

# Test failure scenarios
paymentMethodId: "pm_card_chargeDeclined"  # Always fails
\`\`\`

## Related Endpoints
- `GET /api/cart/:id` - Get cart details
- `POST /api/cart` - Create or update cart
- `GET /api/orders/:id` - Get order details
- `GET /api/payment-methods` - List payment methods
\`\`\`

**Self-Review Using Skills:**
```
✓ (code-reviewer) All code examples are syntactically correct
✓ (ecommerce-validator) Examples follow pricing and validation rules
✓ Complete request/response documentation
✓ Multiple language examples provided
✓ Error cases thoroughly documented
✓ Security considerations included
```

## How Models Use This Agent
When documenting APIs for this project:
1. **Inherits Documentation Skills**: From global documentation-specialist
2. **API-Specific Format**: Uses OpenAPI + Markdown combination
3. **Business Logic Awareness**: Uses ecommerce-validator to ensure examples are realistic
4. **Multi-Language Examples**: Provides curl, JavaScript, and Python examples
5. **Complete Coverage**: Documents happy path, errors, and edge cases

**Note:** This is a **PROJECT-SPECIFIC agent** - it combines general documentation skills with project-specific API documentation requirements and formats.
