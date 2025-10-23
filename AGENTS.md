# AGENTS

This file provides guidance to AI code assistants when working with code in this repository.

## Project Overview

See @README.md for a project overview.

## Architecture Instructions

Use the detailed instructions in @ARCHITECTURE.md when writing code in this project, which **MUST** follow strictly the Domain Resource Action pattern as described there for the folder structure, modules and routes.

## Coding Guidelines

Use the detailed guidelines in @CODING_GUIDELINES.md when writing code in Elixir with the Phoenix framework, but bear in mind that instructions in the @ARCHITECTURE.md have precende over @AGENTS.md.

## Phoenix Development

See the detailed instructions in @PHOENIX_DEVELOPMENT.md on how to setup, test and run a Phoenix application during development.


## Incremental Code Generation Workflow

**IMPORTANT: Before proposing any code for a user request, the AI Coding Agent **MUST** always use the detailed instructions from @PLANNING.md to create Intent(s) and Tasks and sub-tasks to have a  detailed and concise step-by-step plan to accomplish the user request.**

**CRITICAL: After completing each step below, you MUST STOP and WAIT for explicit user approval before proceeding to the next task. When you ask "Ready for task X?", you are NOT allowed to continue until the user responds. NEVER create code for the next task until the user says "yes", "proceed", "continue`, "ok" or similar.**

Work on an Intent at a time, executing step-by-step each task and sub-task from it, with user feedback in between, following the Domain Resource Action pattern as per the detailed instructions at @ARCHITECTURE.md and a TDD approach **MUST** always be used, by writing first the tests, followed by writing the code to make it pass, as a senior engineer with more then a decade of experience would write. The code needs to easy to understand and reason about. For example: create a schema, create unit tests for the schema, create a Domain Resource Action module, create unit tests for it, create the Domain Resource API, create Elixir doctests for it, create the LiveView or Controller in the web layer, then create the integration test for them. When creating tests there is no need to use mocks for accessing the database or other modules the current module depends on. Only create mocks for tests that will reach the external world, third-party APIs.

Repeat the process below for each Task and sub-task on an Intent:

1. **Always ask for user confirmation** before starting to work on an Intent, task or sub-task - this is MANDATORY.
2. **One sub-task at a time:** Do **NOT** start the next sub‑task until you ask the user for permission - - this is MANDATORY.
3. **If user says "continue", "proceed", "yes", "y" or "ok"**, start or continue to the next sub-task, task or Intent.
4. **If user provides feedback**, adjust and re-present your solution
5. **If user says "skip X"**, skip that task, sub-task or Intent.
6. **If user says "edit/refine/refactor X" or similar**, stop and iterate with the user to refine the Intent, task or sub-task.
7. **Keep focused** - don't jump ahead, don't create multiple Intnets, tasks or sub-tasks at once. Use baby-steps.
8. **Brief and consise explanations** - what you did, not verbose details. Start by the most important things to be told, followed by some context, and if really necessary a few more specific details.
. **Always run tests** - once you think you completed a sub-task, task or Intent you **MUST** run `mix test" before commiting you changes

This approach enables early validation, catches issues before coding, and allows mid-course adjustments.

## Task Completion Protocol

The following steps apply:

1. When you finish a **sub‑task**, immediately mark it as completed by changing `[ ]` to `[x]`.
2. If **all** subtasks underneath a parent task are now `[x]`, follow this sequence:
  1. **First**: Run `mix precommit` to run the full test suite and other checks.
  2. **Only if all tests and checks pass**: Run `git add .` to Stage all changes, otherwise go back and fix the tests and other isues reported by the precommit checks.
  3. **Clean up**: Remove any temporary files and temporary code before committing.
  3. **Tasks Tracking**: Once all the subtasks are marked completed and before changes have been committed, mark the **parent task** as completed.
  4. **Git Commit**: Use a descriptive commit message that:
    - Uses this git commit format (`feature (domain-resource): message title`, `bug (domain-resource): message`, `refactor (domain-resource): message title`, `enhancement (domain-resource): message title` etc.)
    - The message title summarizes what was accomplished in the current task. References the Intent and task number.
    - The body of the message lists key changes and additions by the sub-tasks.
    - **Formats the message as a single-line command using `-m` flags**, e.g.:

      ```
      git commit -m "feature (checkout-payments): Adds payment validation logic. Intent-15, Task-2" -m "- Validates card type and expiry" -m "- Supported cards: VISA and Mastercard"-m "- Adds unit tests, including for edge cases"
      ```
3. Stop after each sub‑task, ask for user confirmation that it's satisfied with the implemetation and it wants to go-ahead with the next sub-task. You **MUST** wait for the user's affirmative reply before proceeding.


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
