# Development Workflow

## 1. Running Commands

**CRITICAL:** Don't get stuck in commands that require user interaction. Immediately abort and try to find if the command as a non-interactive flag that can be used. If not use the bash trick `yes | command` or similar.

## 2. Incremental Code Generation Workflow

**IMPORTANT: Before proposing any code for a user request, the AI Coding Agent **MUST** always use the detailed instructions from @PLANNING.md to create Intent(s) and Tasks and sub-tasks to have a  detailed and concise step-by-step plan to accomplish the user request.**

**CRITICAL: You **MUST** never start working on an Intent, task or sub-task if you don't have a clean git working tree. Always check for uncommitted changes with `git status`, and if any exist ask user guidance on how to proceed. Uncommitted changes from your working shoudn't exist, unless you failed to follow the Task Completion Protocol enumerate in this document.**

**CRITICAL: After completing each step below, you MUST STOP and WAIT for explicit user approval before proceeding to the next task. When you ask "Ready for task X?", you are NOT allowed to continue until the user responds. NEVER create code for the next task until the user says "yes", "proceed", "continue`, "ok" or similar.**

Work on an Intent at a time, executing step-by-step each task and sub-task from it, with user feedback in between, following the Domain Resource Action pattern as per the detailed instructions at @ARCHITECTURE.md and a TDD approach **MUST** always be used, by writing first the tests, followed by writing the code to make it pass, as a senior engineer with more then a decade of experience would write. The code needs to easy to understand and reason about. For example: create a schema, create unit tests for the schema, create a Domain Resource Action module, create unit tests for it, create the Domain Resource API, create Elixir doctests for it, create the LiveView or Controller in the web layer, then create the integration test for them. When creating tests there is no need to use mocks for accessing the database or other modules the current module depends on. Only create mocks for tests that will reach the external world, third-party APIs.

### 2.1 Task Implementation Protocol

Repeat each step in the below process for each Task and sub-task on an Intent:

1. **Clean Git Working Tree:** Run `git status` to ensure that doesn't exist uncommitted changes. Before continuing to step 2, ask for user guidance if they exist.
2. **Always ask for user confirmation** before starting to work on an Intent, task or sub-task - this is MANDATORY.
3. **One sub-task at a time:** Do **NOT** start the next sub‑task until you ask the user for permission - - this is MANDATORY.
4. **If user says "continue", "proceed", "yes", "y" or "ok"**, start or continue to the next sub-task, task or Intent.
5. **If user provides feedback**, adjust and re-present your solution
6. **If user says "skip X"**, skip that task, sub-task or Intent.
7. **If user says "edit/refine/refactor X" or similar**, stop and iterate with the user to refine the Intent, task or sub-task.
8. **Keep focused** - don't jump ahead, don't create multiple Intents, tasks or sub-tasks at once. Use baby-steps.
9. **Brief and concise explanations** - what you did, not verbose details. Start by the most important things to be told, followed by some context when it makes sense, and if only if stritcly necessary a few more specific details.
10. **Task Completion** - once you think you completed a sub-task, you **MUST** follow the [Task Completion Protocol](#task-completion-protocol).

This approach enables early validation, catches issues before coding, and allows mid-course adjustments.

### 2.2 Task Completion Protocol

The following steps apply:

1. When you finish a **sub‑task**, you **MUST** immediately mark it as completed by changing `[ ]` to `[x]`. This is **MANDANTORY** to be done before proceeding to the next sub-task or task.
2. If **all** sub-tasks underneath a parent task are now `[x]`, follow this sequence:
  1. **First**: Run `mix precommit` to run the full test suite and other checks.
  2. **Only if all tests and checks pass**: Run `git add .` to Stage all changes, otherwise go back and fix the tests and other issues reported by the precommit checks.
  3. **Clean up**: Remove any temporary files and temporary code before committing.
  3. **Tasks Tracking**: Once all the sub-tasks are marked completed and before changes have been committed, mark the **parent task** as completed.
  4. **Git Commit**: Use a descriptive commit message that:
    - Uses this git commit format (`feature (domain-resource): message title. Intent: number - Task: number .`, `bug (domain-resource): message title .Intent: number - Task: number .`, `refactor (domain-resource): message title. Intent: number - Task: number .`, `enhancement (domain-resource): message title. Intent: number - Task: number .` etc.)
    - The message title summarizes what was accomplished in the current task, followed by a reference to the Intent and Task number.
    - The body of the message lists key changes and additions by the sub-tasks.
    - **Formats the message as a single-line command using `-m` flags**, e.g.:

      ```
      git commit -m "feature (checkout-payments): Adds payment validation logic. Intent: 15, Task: 2" -m "- Validates card type and expiry" -m "- Supported cards: VISA and Mastercard"-m "- Adds unit tests, including for edge cases"
      ```
3. Stop after each sub‑task, ask for user confirmation that it's satisfied with the implementation and it wants to go-ahead with the next sub-task. You **MUST** wait for the user's affirmative reply before proceeding. This must be followed no matter how small the steps in the sub-task are, even if they are baby steps you need to ask user for confirmation before proceeding, except when the next step is to start a sub-task that the only work it does, implicitly or explicitly, is to run a tool, like `mix`, `git`, 'mkdir', 'cp', 'mv', 'ls', etc., because you will prompt anyway to allow or disallow to execute any tool you know about.
