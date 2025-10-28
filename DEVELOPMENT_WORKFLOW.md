# Development Workflow

This document provides guidance to AI coding agents, AI coding assistants and LLMs, often referred to as **you**, for the development workflow to use when working in this project. 


## 1. Running Commands

**CRITICAL: Don't get stuck in commands that require user interaction. Immediately abort and try to find if the command as a non-interactive flag that can be used. If not use the bash trick `yes | command` or similar.**


## 2. TDD First

**CRITICAL: First, you **MUST** write the tests, then you can write the application code to make them pass, as a senior engineer with more then a decade of experience would write.**

**IMPORTANT: When creating tests there is no need to use mocks for accessing the database or other modules the current module depends on. Only create mocks for tests that will reach the external world, third-party APIs.**

This TDD steps **MUST** be used always:

1. First, create the Module for the application code with the public function, but no logic on it, only returning `:todo`.
2. Next, create the test Module with only one test for the main success scenario.
2. Then run `mix test module_test_file` and the test **MUST** fail, because the application code is returning `:todo`, as the application code logic to make it pass wasn't written yet. If the test fails because of any other reason (e.g. syntax errors, missing imports, compilation warnings or errors, etc.) then you **MUST** fix them before proceeding to the next step.
3. Now, implement the minimal amount of application code to make the test pass. 
The code needs to be easy to understand, reason about, and change, just as a senior engineer with more then a decade of experience would write.
4. Repeat this steps by going back to step 1. again. This **MUST** be repeated until the test suite covers:
  - all success scenarios.
  - all failure scenarios.
  - all edge cases. 
  - all code paths.

**IMPORTANT:** To translate this TDD first approach to tasks and sub-task see the INTENT_EXAMPLE.md file to implement the CRUD actions for a Domain Resource in the business logic and web logic layers.

## 3. Incremental Code Generation Workflow

**IMPORTANT: Before proposing any code for a user request, the AI Coding Agent **MUST** always use the detailed instructions from PLANNING.md to create Intent(s) and Tasks and sub-tasks to have a detailed and concise step-by-step plan to accomplish the user request.**

**CRITICAL: You **MUST** never start working on an Intent, task or sub-task if you don't have a clean git working tree. Always check for uncommitted changes with `git status`, and if any exist ask user guidance on how to proceed. Uncommitted changes from your working shouldn't exist, unless you failed to follow the Task Completion Protocol enumerate in this document.**

**CRITICAL: After completing each step below, you MUST STOP and WAIT for explicit user approval before proceeding to the next task. When you ask "Ready for task X?", you are NOT allowed to continue until the user responds. NEVER create code for the next task until the user says "yes", "proceed", "continue`, "ok" or similar.**

Work on an Intent at a time, executing step-by-step each task and sub-task from it, with user feedback in between, following the Domain Resource Action pattern as per the detailed instructions at ARCHITECTURE.md.

You **MUST** not try to propose code changes for multiple task or sub-tasks in one go. Always keep code changes focused on the sub-task being executed.


## 4. Task Implementation Protocol

Repeat each step in the below process for each Task and sub-task on an Intent:

1. **Clean Git Working Tree:** Run `git status` to ensure that doesn't exist uncommitted changes. Before continuing to step 2, ask for user guidance if they exist.
2. **Always ask for user confirmation** before starting to work on an Intent task - this is MANDATORY. Sub-tasks don't require user confirmation before proceeding to the next one.
3. **If user says "continue", "proceed", "yes", "y" or "ok"**, start or continue to work on the Intent Task.
4. **One sub-task at a time:** You **MUST** only propose code changes for one single sub-task. Do **NOT** try to add code changes to accomplish more then one sub-task. This is MANDATORY.
5. **If user provides feedback**, adjust and re-present your solution.
6. **If user says "skip X"**, skip that task, sub-task or Intent.
7. **If user says "edit/refine/refactor X" or similar**, stop and iterate with the user to refine the Intent, task or sub-task.
8. **Keep focused** - don't jump ahead, don't create multiple Intents, tasks or sub-tasks at once. Use baby-steps.
9. **Brief and concise explanations** - what you did, not verbose details. Start by the most important things to be told, followed by some context when it makes sense, and if only if strictly necessary a few more specific details.
10. **Task Completion** - once you think you completed a sub-task, you **MUST** follow the [Task Completion Protocol](#task-completion-protocol).

This approach enables early validation, catches issues before coding, and allows mid-course adjustments.

## 5. Task Completion Protocol

**INFO:** The `mix precommit` alias can be checked in the `mix.exs` file aliases section.

The following steps apply:

1. When you finish a **sub‑task**, you **MUST** immediately mark it as completed by changing `[ ]` to `[x]`. This is **MANDANTORY** to be done before proceeding to the next sub-task or task. You **MUST** run `mix test` to confirm that all tests are passing without warnings or errors during the compilation, otherwise you need to fix them.
2. If **all** sub-tasks underneath a parent task are now `[x]`, follow this sequence:
  1. **First**: Run `mix precommit` to run the full test suite and other checks.
  2. **Only if all tests and checks pass**: Run `git add .` to Stage all changes, otherwise go back and fix the tests and other issues reported by the precommit checks.
  3. **Clean up**: Remove any temporary files and temporary code before committing.
  3. **Tasks Tracking**: Once all the sub-tasks are marked completed and before changes have been committed, mark the **parent task** as completed.
  4. **Git Commit**: Use a descriptive commit message that:
    - Uses this type of git commit format: `Intent (domain-resource): Intent number - Intent title.`, `feature (domain-resource): message title. Intent: number - Task: number .`, `bug (domain-resource): message title .Intent: number - Task: number .`, `refactor (domain-resource): message title. Intent: number - Task: number .`, `enhancement (domain-resource): message title. Intent: number - Task: number .` etc.
    - Except for when committing an Intent, the message title summarizes what was accomplished in the current task, followed by a reference to the Intent and Task number.
    - The body of the message lists key changes and additions by the sub-tasks.
    - **Formats the message as a single-line command using `-m` flags**, examples:
      - To commit an Intent creation:

      ```
      git commit -m "intent (checkout-payments): Intent 15 Planning - Add support for Visa Card payments." -m "Intent planned tasks:" -m "- List one task per -m flag without mentioning sub-tasks"
      ```

      - To commit features, enhancement, bug, docs, chore, etc.:

      ```
      git commit -m "feature (checkout-payments): Implemented payment validation logic. Intent: 15, Task: 2" -m "- Validates card type and expiry" -m "- Adds unit tests, including for edge cases"
      ```
3. Stop after each task, ask for user confirmation that it's satisfied with the implementation of all sub-tasks and that it wants to go-ahead with the next task. You **MUST** wait for the user's affirmative reply before proceeding. This **MUST** be followed no matter how many sub-tasks are in the task, except when the only work to be executed by the sub-tasks are to, implicitly or explicitly, run tools, like `mix`, `git`, 'mkdir', 'cp', 'mv', 'ls', etc., because you always prompt the user to allow or disallow to execute any tool you know about.

