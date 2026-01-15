# 📘 Implementation Guide: Creating Your Own Agents and Skills

This guide shows you **how to create** your own agents and skills for Claude. Follow these steps to customize for your project!

---

## 🎯 Quick Start Checklist

- [ ] Identify what makes your project unique
- [ ] Decide between global vs project-specific configs
- [ ] Choose agent(s) to create or extend
- [ ] Identify needed skills
- [ ] Write configurations with examples
- [ ] Test with real tasks
- [ ] Iterate and improve

---

## 📋 Step 1: Analyze Your Project

### Questions to Ask

**Domain:**
- What industry/domain is this? (e.g., healthcare, finance, education)
- What are the core business concepts? (e.g., patients, transactions, courses)
- What rules must always be followed? (e.g., HIPAA compliance, audit trails)

**Tech Stack:**
- What languages? (JavaScript, Python, Java, etc.)
- What frameworks? (React, Django, Spring Boot, etc.)
- What database? (PostgreSQL, MongoDB, MySQL, etc.)
- What patterns? (REST, GraphQL, microservices, etc.)

**Team Conventions:**
- Coding style guide?
- Testing frameworks and approach?
- Documentation format?
- Deployment process?

### Example Analysis: Healthcare App

```yaml
domain: "Healthcare"
business_concepts:
  - patients
  - appointments
  - medical_records
  - prescriptions
compliance:
  - HIPAA
  - PII protection
  - audit logging required
  
tech_stack:
  backend: "Python + Django"
  database: "PostgreSQL"
  api: "REST + Django REST Framework"
  auth: "OAuth2 + JWT"
  
conventions:
  style: "PEP 8"
  testing: "pytest"
  documentation: "Sphinx + docstrings"
```

---

## 📝 Step 2: Plan Your Configuration Structure

### Decision Tree

```
Do you need project-specific behavior?
├─ NO → Use global agents/skills as-is
└─ YES → Create project configs
    │
    ├─ Is it general-purpose?
    │  └─ YES → Add to .github/ (global)
    │
    └─ Is it project-specific?
       └─ YES → Add to .claude/ (project)
```

### Common Patterns

| Pattern | Location | Example |
|---------|----------|---------|
| Reusable across projects | `.github/` | senior-developer, code-reviewer |
| Domain-specific | `.claude/` | healthcare-validator, hipaa-checker |
| Tech-stack specific | `.claude/` | django-developer, react-component-builder |

---

## 🎭 Step 3: Create an Agent

### Agent Template

Create a new file: `.claude/agents/your-agent-name.md`

```markdown
# [Agent Name]

## Agent Identity
**Name:** [Short Name]
**Role:** [What this agent does]
**Scope:** Project (or Global)

## Agent Extends (if applicable)
```yaml
extends: .github/agents/[base-agent]
project_context: [your-project-name]
```

## Personality & Approach
- **[Trait 1]**: [Description]
- **[Trait 2]**: [Description]
- **[Trait 3]**: [Description]

## Skills
This agent has access to:
- `[skill-name]` - [Description]
- `[skill-name]` - [Description]

## Responsibilities
1. **[Area 1]**: [Description]
2. **[Area 2]**: [Description]
3. **[Area 3]**: [Description]

## Decision-Making Framework
When [situation], this agent should:
1. **[Step 1]**: [Description]
2. **[Step 2]**: [Description]
3. **[Step 3]**: [Description]

## Example Usage
```yaml
agent: [agent-name]
task: "[Example task]"
context:
  - "[Context item 1]"
  - "[Context item 2]"
```

## Interactive Example: [Scenario Name]

**Scenario:** [Description]

**Agent's Approach:**
```
[Show thinking process]
```

**Agent's Output:**
```[language]
[Show actual code or content output]
```

**Self-Review Using Skills:**
```
[Show validation output]
```

## How Models Use This Agent
When you specify this agent for a task:
1. **[Step 1]**: [What happens]
2. **[Step 2]**: [What happens]
3. **[Step 3]**: [What happens]

## Project Context (for project agents)
```yaml
project:
  name: "[Project name]"
  stack:
    [key]: "[value]"
  patterns:
    [key]: "[value]"
```

**Note:** This is a **[GLOBAL/PROJECT]** agent - [explanation]
```

### Real Example: Healthcare Backend Developer

```markdown
# Healthcare Backend Developer

## Agent Identity
**Name:** Healthcare Backend Developer
**Role:** Implement HIPAA-compliant backend features
**Scope:** Project

## Agent Extends
```yaml
extends: .github/agents/senior-developer
project_context: healthcare-application
specialization: hipaa-compliance
```

## Personality & Approach
- **Privacy-First**: Always considers PII protection
- **Compliant**: Ensures HIPAA requirements are met
- **Audit-Aware**: Logs all access to sensitive data
- **Secure**: Extra vigilant about data encryption

## Skills
This agent has access to:
- `code-reviewer` - (Global) General code quality
- `test-generator` - (Global) Test creation
- `hipaa-validator` - (Project) HIPAA compliance checking
- `phi-protector` - (Project) Protected Health Information safety

## Responsibilities
1. **Patient Data Management**: Handle patient records securely
2. **Access Control**: Implement role-based access (doctor, nurse, admin)
3. **Audit Logging**: Log all PHI access and modifications
4. **Data Encryption**: Ensure data is encrypted at rest and in transit
5. **Compliance**: Meet all HIPAA technical safeguards

## Decision-Making Framework
When implementing features involving PHI:
1. **Classify Data**: Is this PHI (Protected Health Information)?
2. **Apply Encryption**: Encrypt PHI at rest and in transit
3. **Implement Access Control**: Who should have access?
4. **Add Audit Logging**: Log all access with timestamp, user, action
5. **Verify Compliance**: Does this meet HIPAA requirements?

## Example Usage
```yaml
agent: healthcare-backend-developer
task: "Implement patient medical record retrieval endpoint"
context:
  - "Must be HIPAA compliant"
  - "Only authorized healthcare providers can access"
  - "All access must be logged for audit trail"
```

## Interactive Example: Medical Record Access

**Scenario:** Create endpoint to retrieve patient medical records

**Agent's Output:**
```python
"""
Patient Medical Record Endpoint
HIPAA Compliant Implementation

Security Measures:
- Requires OAuth2 authentication
- Role-based access control (provider must be treating physician)
- All PHI access logged for audit
- Data encrypted in transit (HTTPS)
- Minimum necessary principle (only return needed fields)
"""

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.db import transaction
from .models import MedicalRecord, Patient, AuditLog
from .permissions import IsHealthcareProvider

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsHealthcareProvider])
def get_medical_record(request, patient_id, record_id):
    """
    Retrieve a specific medical record for a patient.
    
    HIPAA Safeguards:
    - Authentication required (164.312(a)(1))
    - Access controls (164.312(a)(2))
    - Audit controls (164.312(b))
    - Integrity controls (164.312(c))
    """
    
    try:
        # Verify patient exists
        patient = Patient.objects.get(id=patient_id)
        
        # Verify provider has authorization to access this patient
        # (Treatment relationship must exist)
        if not request.user.has_treatment_relationship_with(patient):
            # Log unauthorized access attempt (HIPAA requirement)
            AuditLog.objects.create(
                user=request.user,
                action='UNAUTHORIZED_ACCESS_ATTEMPT',
                resource_type='MedicalRecord',
                resource_id=record_id,
                patient=patient,
                ip_address=request.META.get('REMOTE_ADDR'),
                reason='No treatment relationship'
            )
            
            return Response(
                {'error': 'Not authorized to access this patient'},
                status=403
            )
        
        # Retrieve medical record
        record = MedicalRecord.objects.get(
            id=record_id,
            patient=patient
        )
        
        # Log PHI access (HIPAA audit requirement - 164.312(b))
        AuditLog.objects.create(
            user=request.user,
            action='PHI_ACCESS',
            resource_type='MedicalRecord',
            resource_id=record.id,
            patient=patient,
            ip_address=request.META.get('REMOTE_ADDR'),
            reason=request.query_params.get('reason', 'Treatment')
        )
        
        # Return record (minimum necessary - only include needed fields)
        # Data transmitted over HTTPS (encryption in transit - 164.312(e))
        return Response({
            'record': {
                'id': record.id,
                'patient_id': patient.id,
                'date': record.date,
                'diagnosis': record.diagnosis,
                'treatment': record.treatment,
                'provider': record.provider.name,
                'notes': record.notes
                # SSN, billing info not included (minimum necessary)
            }
        }, status=200)
        
    except Patient.DoesNotExist:
        return Response({'error': 'Patient not found'}, status=404)
    
    except MedicalRecord.DoesNotExist:
        return Response({'error': 'Medical record not found'}, status=404)
    
    except Exception as e:
        # Log error without exposing PHI
        logger.error(f"Error retrieving medical record: {str(e)}")
        return Response(
            {'error': 'Failed to retrieve medical record'},
            status=500
        )
```

**Self-Review Using Skills:**
```
✓ (code-reviewer) Proper error handling, no PHI in logs
✓ (hipaa-validator) Meets HIPAA technical safeguards:
  - Authentication: ✓ (164.312(a)(1))
  - Access Control: ✓ (164.312(a)(2))
  - Audit Controls: ✓ (164.312(b))
  - Integrity: ✓ (164.312(c))
  - Encryption: ✓ (164.312(e)) - HTTPS transport
✓ (phi-protector) PHI properly protected:
  - Minimal data exposure ✓
  - Audit logging ✓
  - Access control ✓
  - No PHI in error messages ✓
```

## Project Context
```python
# Django REST Framework patterns
@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])

# Database: PostgreSQL with encryption at rest
# ORM: Django ORM
# Auth: OAuth2 + JWT

# All PHI fields use encrypted database columns
# Audit logs retained for 7 years (HIPAA requirement)
```

**Note:** This is a **PROJECT-SPECIFIC agent** specialized for HIPAA-compliant healthcare applications.
```

---

## 🛠️ Step 4: Create a Skill

### Skill Template

Create a new file: `.claude/skills/your-skill-name.md`

```markdown
# [Skill Name]

## Purpose
[What this skill does and why it exists]

## Skill Definition
**Skill Name:** [short-name]
**Type:** [Analysis/Generation/Validation/etc.]
**Scope:** [Global/Project]

## Capabilities
- **[Capability 1]**: [Description]
- **[Capability 2]**: [Description]
- **[Capability 3]**: [Description]

## Usage Pattern
When an agent invokes this skill, it should:
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Example Invocation
```yaml
skills:
  - [skill-name]

task: "[Example task]"
context:
  - [context item]
```

## Best Practices for This Skill
- **[Practice 1]**: [Description]
- **[Practice 2]**: [Description]
- **[Practice 3]**: [Description]

## Interactive Example
```[language]
// INPUT:
[Show example input]

// SKILL OUTPUT:
[Show expected output format]
```

## Configuration Options
```json
{
  "[option1]": "[value]",
  "[option2]": "[value]"
}
```

## How Models Use This Skill
When Claude applies this skill:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Note:** This is a **[GLOBAL/PROJECT]** skill - [explanation]
```

### Real Example: HIPAA Validator Skill

```markdown
# HIPAA Validator Skill

## Purpose
Validates that code implementations meet HIPAA technical safeguards requirements for protecting PHI.

## Skill Definition
**Skill Name:** hipaa-validator
**Type:** Compliance Validation
**Scope:** Project (Healthcare applications)

## Capabilities
- **Authentication Check**: Verifies user authentication is required
- **Access Control**: Ensures role-based access to PHI
- **Audit Logging**: Confirms all PHI access is logged
- **Encryption**: Validates encryption in transit and at rest
- **Minimum Necessary**: Checks only needed data is exposed

## Usage Pattern
When validating healthcare code:
1. Identify if code touches PHI (Protected Health Information)
2. Check authentication and authorization
3. Verify audit logging is present
4. Confirm encryption requirements are met
5. Validate minimum necessary principle

## Example Invocation
```yaml
skills:
  - hipaa-validator

task: "Review patient data endpoint for HIPAA compliance"
context:
  - file: "api/patients.py"
  - regulation: "HIPAA 164.312"
```

## Best Practices for This Skill
- **Always Log PHI Access**: Every access must create audit trail
- **Encrypt in Transit**: All PHI must use HTTPS
- **Encrypt at Rest**: Database fields with PHI must be encrypted
- **Least Privilege**: Only give access needed for job function
- **Minimum Necessary**: Only return/expose needed data fields

## Interactive Example
```python
# CODE TO VALIDATE:
@api_view(['GET'])
def get_patient(request, patient_id):
    patient = Patient.objects.get(id=patient_id)
    return Response(patient.to_dict())

# SKILL OUTPUT:
{
  "hipaa_compliance": "FAILED",
  "violations": [
    {
      "safeguard": "164.312(a)(1) - Authentication",
      "severity": "critical",
      "issue": "No authentication required",
      "fix": "Add @permission_classes([IsAuthenticated])"
    },
    {
      "safeguard": "164.312(b) - Audit Controls",
      "severity": "critical",
      "issue": "PHI access not logged",
      "fix": "Add AuditLog.create() before returning data"
    },
    {
      "safeguard": "164.502(b) - Minimum Necessary",
      "severity": "high",
      "issue": "Returns all patient fields including SSN",
      "fix": "Return only fields needed for this operation"
    }
  ],
  "recommendations": [
    "Add authorization check (not just authentication)",
    "Consider rate limiting to prevent data scraping",
    "Sanitize error messages to not expose PHI"
  ]
}
```

## HIPAA Safeguards Checklist
- [ ] 164.312(a)(1) - Authentication required
- [ ] 164.312(a)(2) - Access controls implemented
- [ ] 164.312(b) - Audit trail created
- [ ] 164.312(c)(1) - Data integrity maintained
- [ ] 164.312(e)(1) - Encryption in transit (HTTPS)
- [ ] 164.312(e)(2) - Encryption at rest
- [ ] 164.502(b) - Minimum necessary principle
- [ ] 164.514(d) - Business associate agreement (if applicable)

## Configuration Options
```json
{
  "strictness": "high",
  "regulations": ["HIPAA"],
  "require_audit_logging": true,
  "require_encryption": true,
  "check_minimum_necessary": true
}
```

## How Models Use This Skill
When Claude validates with this skill:
1. **Identify PHI**: Determine if code handles Protected Health Information
2. **Check Safeguards**: Verify each required HIPAA safeguard
3. **Report Violations**: List specific compliance failures with severity
4. **Suggest Fixes**: Provide concrete code changes to achieve compliance
5. **Consider Context**: Apply regulations appropriately for the use case

**Note:** This is a **PROJECT-SPECIFIC skill** for healthcare applications subject to HIPAA.
```

---

## 🧪 Step 5: Test Your Configurations

### Testing Checklist

Create test scenarios:

```markdown
## Test Scenario 1: [Description]
**Agent:** [agent-name]
**Task:** "[task description]"
**Expected:** [what should happen]
**Actual:** [what happened]
**Pass/Fail:** [result]

## Test Scenario 2: [Description]
...
```

### Example Tests

```markdown
## Test 1: Global Agent Inheritance
**Agent:** healthcare-backend-developer
**Extends:** senior-developer
**Test:** Does it inherit decision-making framework?
**Expected:** Should follow "Understand→Consider→Assess→Choose→Document"
**Result:** ✅ PASS - Framework applied correctly

## Test 2: Skill Application
**Agent:** healthcare-backend-developer
**Skills:** code-reviewer, hipaa-validator
**Test:** Generate patient endpoint
**Expected:** Code includes auth, audit logging, encryption
**Result:** ✅ PASS - All HIPAA safeguards included

## Test 3: Project Conventions
**Agent:** healthcare-backend-developer
**Test:** Uses Django patterns?
**Expected:** @api_view decorator, DRF Response, etc.
**Result:** ✅ PASS - Follows project conventions
```

---

## 📊 Step 6: Iterate and Improve

### Improvement Cycle

```
1. Use agent/skill in real task
   ↓
2. Observe output quality
   ↓
3. Identify gaps or errors
   ↓
4. Update configuration
   ↓
5. Test again
   ↓
(Repeat)
```

### What to Look For

**Good Signs:**
- ✅ Code follows project patterns without prompting
- ✅ Business rules automatically applied
- ✅ Consistent error handling
- ✅ Proper tech stack usage

**Red Flags:**
- ❌ Generic code that doesn't match project
- ❌ Missing business logic
- ❌ Wrong framework/library usage
- ❌ Need to repeat same corrections

### Example Improvement

**Initial Version:**
```markdown
## Skills
- code-reviewer
```

**After Testing:**
```markdown
## Skills
- code-reviewer (global)
- test-generator (global)
- hipaa-validator (project) ← Added after noticing missing compliance
- phi-protector (project) ← Added after PII exposure incident
```

---

## 🎯 Step 7: Document for Your Team

### Create a Team Guide

```markdown
# Claude Agents for [Your Project]

## Available Agents
1. **[Agent 1]** - [When to use]
2. **[Agent 2]** - [When to use]

## Quick Reference
| Task Type | Agent to Use | Expected Outcome |
|-----------|-------------|------------------|
| [Task] | [Agent] | [Outcome] |

## Examples
[Provide team-specific examples]

## Best Practices
[Your team's conventions]
```

---

## 📚 Common Patterns

### Pattern 1: Compliance-Focused

**Use for:** Regulated industries (healthcare, finance)
**Structure:**
```
Base: senior-developer
Project: [domain]-backend-developer
Skills: [compliance]-validator, [data-protection]
```

### Pattern 2: Framework-Specific

**Use for:** Specific tech stacks
**Structure:**
```
Base: senior-developer
Project: [framework]-developer (e.g., django-developer)
Skills: [framework]-best-practices, [orm]-patterns
```

### Pattern 3: Domain-Driven

**Use for:** Complex business domains
**Structure:**
```
Base: senior-developer
Project: [domain]-specialist (e.g., e-commerce-specialist)
Skills: [domain]-validator, [domain]-patterns
```

---

## 💡 Pro Tips

1. **Start Small**: Begin with one agent and skill
2. **Copy and Adapt**: Use examples as templates
3. **Be Specific**: Concrete examples beat vague descriptions
4. **Test Frequently**: Try in real tasks immediately
5. **Iterate**: Configurations improve with use
6. **Document Why**: Explain reasoning in configs
7. **Keep Updated**: Evolve as project changes
8. **Share Knowledge**: Help teammates understand

---

## ❓ Troubleshooting

### Problem: Generic Output
**Solution:** Add more specific examples in agent/skill definitions

### Problem: Wrong Tech Stack
**Solution:** Add project context section with tech details

### Problem: Missing Business Rules
**Solution:** Create domain-specific validator skill

### Problem: Inconsistent Patterns
**Solution:** Add code examples showing exact patterns

### Problem: Skills Not Applied
**Solution:** Explicitly list skills in agent definition

---

## 🎓 Advanced Topics

### Skill Composition
```yaml
agent: complex-agent
skills:
  - base-skill
  - specialized-skill (extends: base-skill)
  - domain-skill
```

### Conditional Behavior
```markdown
When [condition]:
  Apply [approach A]
Otherwise:
  Apply [approach B]
```

### Multi-Agent Workflows
```markdown
1. Agent A: Design
2. Agent B: Implementation
3. Agent C: Review
4. Agent D: Documentation
```

---

## ✅ Success Criteria

Your configurations are working when:

- [ ] Code matches project conventions without prompting
- [ ] Business rules automatically applied
- [ ] Fewer corrections needed
- [ ] Consistent quality across tasks
- [ ] Team members can use effectively
- [ ] Saves time overall

---

## 🚀 Next Steps

1. ✅ Use this guide to create your first agent
2. → Test with a real task
3. → Iterate based on results
4. → Expand to more agents/skills
5. → Share with your team

**Good luck! You're now ready to create powerful Claude configurations! 🎉**
