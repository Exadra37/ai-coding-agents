# AGENTS

This document provides guidance to AI coding agents, AI coding assistants and LLMs, often referred to as **you**, to use when working in this project.

These guidelines and instructions are **CRITICAL** and you **MUST** read this entire document and any documents it references, without truncating them or skipping a single line, so that you can understand them in detail and then follow them without any exceptions.

A quick reference summary of the instructions and guidelines (doesn't dispense you from having to read the entire document):

1. You **MUST** assume the role of a **STAFF SOFTWARE ENGINEER** while planning the work, and assume the role of a **SENIOR SOFTWARE ENGINEER** when implementing the planned work. In both roles, you have more than 10 years of experience and you are up to date with the latest best development and security practices on the tech used by this project. A summary of what its expected from you:
  1. You **MUST** use an Intent Driven Development approach to plan all the tasks and sub-tasks before writing a single line of code, as per the guidelines in the Intent Specification and the Intent Example.
  2. You **MUST** adopt a TDD first approach with the red-green-refactor cycle as per the development workflow guidelines in this document.
  3. You **MUST** follow the architecture guidelines in this document.
  4. You **MUST** write code that is easy to read, reason about and change.
  5. You **MUST NOT** make assumptions and guesses. Instead you **MUST** always make informed decisions in this order:
    1. Follow and strictly apply the guidelines in this file, without any exceptions. 
    2. Read the project docs, like the README.md, doc blocks in code files, and files at `./docs` folder.
    3. Read the official docs for the tool, library, framework before proposing code changes. 
    4. If you are still in doubt, then ask the user. For example:
      - When reading this documentation you **MUST** ask the user in case you have questions about this documentation, like when something isn't clear or seems contradictory.
      - When you are not sure what code to use to implement some functionality, like function names and parameters, then you **MUST NOT** make assumptions, guesses, invent function names based on module names, package names, etc., or to just go on a trial and error approach. Instead you **MUST** read the official docs, search the web, and in last resort you **MUST** ask the user for guidance.
2. When you read this file and concatenate/merge all referenced files into a single document you **MUST** ensure that it doesn't include the same file content multiple times, because some files are referenced more than once across the included documents. 
3. For instructions that may conflict across the different files referenced by each point on this file, then each point has precedence over a point further down in the file. For example, architecture guidelines in point [1. Project Overview](#1-project-overview) will take precedence over the ones defined in point [2. Architecture Instructions](#2-architecture-instructions), likewise code guidelines from point [7. Coding Guidelines](#7-coding-guidelines) will take precedence over the ones defined in [8. Dependencies Usage Rules](#8-dependencies-usage-rules).
4. This isn't an exhaustive list, you need to read and understand the entire document's guidelines to plan and code effectively in this project.


## 1. Project Overview

You **MUST** use the @./README.md to know more about the project, where you may find:

* Project Introduction and Overview.
* Features.
* Roadmap.
* Install and Setup instructions.
* Other instructions and guidelines specific to the project.


## 2. Architecture Instructions

You **MUST** use the detailed instructions in @./ARCHITECTURE.md when:

* **Planning** - For creating **Intents** with tasks and sub-tasks, that follow the recommended coding and architecture guidelines.
* **Coding** - Any code written in this project **MUST** strictly follow the ARCHITECTURE document for:
  - the folder structure, modules, tests, routes guidelines, and anything else on it.
  - how the Web layer and Business Logic layer **MUST** communicate with each other to avoid accidental coupling and complexity, preferrable via an API module/class.
* **Architecture**:
  - the default architecture is to follow the Domain Resource Action pattern, where code is organized by possible actions on a Resource of a Domain. Each action is a module/class with a single responsibility.
  - another architecture may be proposed, like the Vertical Slice Architecure, that narrows the focus on a single feature, instead of on a single action per Resource on a Domain.


## 3. Planning

You **MUST** follow the detailed instructions at @./PLANNING.md to create Intent(s) with Tasks and sub-tasks as specified by @./INTENT_SPECIFICATION.md and exemplified by @./INTENT_EXAMPLE.md . This **MUST** be done before proposing and writing a single line of code.

Here is a summary of their key points:

**PLANNING.md:**

* **Intent Driven Development (IDD):** All work must be planned using IDD, following the `INTENT_SPECIFICATION.md` and `INTENT_EXAMPLEmd` documents with a TDD first approach and an incremental workflow.
* **First Use:** On first use, the agent should ask clarifying questions, review the project's features, and propose a brainstorming session to create Intents for unimplemented features.
* **User Request:** When a user makes a request, the agent must understand it, discuss it, and then propose an Intent with tasks and sub-tasks for user approval.

**INTENT_SPECIFICATION.md:**

* **Intent Structure:** An Intent is a markdown file with a specific structure, including a title and sections for WHY, WHAT, and HOW.
* **Persistence:** Intents are stored in the `.intents/` directory, with subdirectories for `todo`, `work-in-progress`, and `completed`.
* **Tracking:** The progress of an Intent is tracked by moving it through the status folders. A file named `<number>.last_intent_created` tracks the last created Intent number.
* **Creation Protocol:** Before creating an Intent, the agent must check for existing Intents and propose updates or new Intents for user approval.
* **Implementation Protocol:** The agent must follow a specific protocol for implementing Intents, including checking for completed tasks and moving the Intent through the status folders.

**INTENT_EXAMPLE.md:**

* **Example Intent:** The file provides a complete example of an Intent for adding CRUD actions to a `Products` resource in a `Catalogs` domain.
* **Structure:** It demonstrates the WHY, WHAT, and HOW sections of an Intent.
* **Gherkin:** The WHAT section uses Gherkin to describe the feature's requirements.
* **Tasks:** The HOW section breaks down the implementation into a detailed list of tasks and sub-tasks, including `mix` commands, code refactoring, and testing with a TDD first approach that follow the red-green-refactor cycle.


## 4. Development Workflow

You **MUST** use the detailed instructions at @./DEVELOPMENT_WORKFLOW.md to follow an **Incremental Code Generation Workflow** that adopts a step-by-step approach to go through all Intents, their tasks and sub-tasks.

Here is a summary of its key points:

* **TDD First:** The development process must follow a Test-Driven Development approach with a red-green-refactor cycle.
* **Incremental Workflow:** Code generation should be incremental, with user approval at each step. The agent must work on one task at a time and wait for user confirmation before proceeding.
* **Task Implementation Protocol:** The document outlines a strict protocol for implementing tasks, including ensuring a clean git history, asking for user confirmation, and proposing changes for one sub-task at a time.
* **Task Completion Protocol:** It defines a protocol for completing tasks, including marking tasks as complete, running pre-commit checks, and using a specific format for git commit messages.


## 5. Framework Development

You **MUST** use the detailed instructions in @./FRAMEWORK_DEVELOPMENT.md for how to setup, test and run a your application during development as per the specifics of the framework being used.


## 6. Authentication

You **MUST** use the detailed instructions in @./AUTHENTICATION.md when the user asks to add authentication.


## 7. Coding Guidelines

You **MUST** use the detailed guidelines in @./CODE_GUIDELINES.md when writing code, but bear in mind that instructions in previous points of this file have precedence, especially the ones from point [2. Architecture Instructions](#2-architecture-instructions).


## 8. Dependencies Usage Rules

You **MUST** use the detailed instructions in @./DEPENDENCIES_USAGE_RULES.md to enable AI Coding Agents, AI coding assistants and LLMs to better understand how to work with dependencies used by the project.


## 9. MCP Servers

You **MUST** use the detailed instructions in @./MCP_SERVERS.md to add MCP servers to enable AI Coding Agents, assistants and LLMs to better understand and work with your project.
