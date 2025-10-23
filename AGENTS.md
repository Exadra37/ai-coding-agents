# AGENTS

This file provides guidance to AI coding agents and assistants when working with code in this repository.

## Project Overview

See @README.md for a project overview.

## Planning

Follow the detailed instructions at @PLANNING.md to create Intent(s), Tasks and sub-tasks before propose and writing a single line of code.

## Architecture Instructions

Use the detailed instructions in @ARCHITECTURE.md when writing code in this project, which **MUST** follow strictly the Domain Resource Action pattern as described there for the folder structure, modules and routes.

## Coding Guidelines

Use the detailed guidelines in @CODING_GUIDELINES.md when writing code in Elixir with the Phoenix framework, but bear in mind that instructions in the @ARCHITECTURE.md have precende over @AGENTS.md.

## Phoenix Development

See the detailed instructions in @PHOENIX_DEVELOPMENT.md on how to setup, test and run a Phoenix application during development.

## Development Workflow

See the detailed instructions at @DEVELOPMENT_WORKFLOW.md to follow an **Incremental Code Generation Workflow** that adopts baby step-by-step to got through all Intents, their tasks and sub-tasks.


### Step 0: Documentation Check (complex components only)

For first-time or complex components:
1. Read relevant `akka-context/java/*.html.md`
2. Extract code examples, verify imports/patterns
3. Brief note: "ðŸ“š Reviewed {doc}"

### Step 1: Design & Planning

Present concise design:
```markdown
## Proposed Design

### Components
- Entity: CreditCardEntity (Event Sourced - need audit trail)
- View: CreditCardsByCardholderView
- Endpoint: CreditCardEndpoint

### Domain Model
**CreditCard (state):** cardId, cardNumber, cardholderName, creditLimit, currentBalance, active

**Events:** CardActivated, CardCharged, PaymentMade, CardBlocked

**Commands:** activate, charge, makePayment, block

### Integration
- View consumes: CardActivated, CardCharged, PaymentMade, CardBlocked
- Endpoint exposes: POST /cards/{id}/activate, POST /cards/{id}/charge, GET /cards/by-cardholder/{name}

Does this design look good? Should I proceed?
```

**STOP and wait for user approval**

### Step 2: Domain Layer

Create domain classes. Verify with `mvn compile`.

Report briefly:
```markdown
Created domain layer:
- domain/CreditCard.java (4 events)
- domain/CreditCardEvent.java

Ready for Entity?
```

**STOP and wait for user approval**

### Step 3: Application Layer

Create one component at a time, with user feedback in between.

Create application components. Verify with `mvn compile`.

Report briefly:
```markdown
Created application layer entity:
- application/CreditCardEntity.java (5 command handlers)

Please review.

Ready for tests?
```

**STOP and wait for user approval**

### Step 4: Tests

Create one test at a time, with user feedback in between.

Create tests for the component in the previous step. Verify with `mvn test` or with `mvn verify` for IntegrationTest.

Report briefly:
```markdown
Created tests:
- CreditCardEntityTest.java (8 test cases)

Please review.

Ready for API layer?
```

**STOP and wait for user approval**

### Step 5: API Layer

Create/update endpoint. Verify with `mvn compile`.

Report briefly:
```markdown
Updated API layer:
- api/CreditCardEndpoint.java
  - POST /cards/{id}/activate
  - POST /cards/{id}/charge
  - GET /cards/by-cardholder/{name}

Please review.

Ready for integration tests?
```

**STOP and wait for user approval**

### Step 6: API Layer integration tests

Create tests for the endpoint in the previous step. Verify with `mvn verify`.

Report briefly:
```markdown
Created tests:
- CreditCardEndpointIntegrationTest.java (6 test cases)

Please review.

Do you also want me to update the readme and include example curl commands of the endpoint?
```

**STOP and wait for user approval**

### Step 7: Documentation

```markdown
Updated README.md with curl examples.

Done! Created 2 domain classes, 1 entity, 1 view, 3 tests, 1 endpoint.
```
