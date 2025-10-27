# AGENTS

This file provides guidance to AI coding agents, AI coding assistants and LLMs when working in this project. Often referred to as **you**.

This instructions are **CRITICAL** and you **MUST** follow them without any exceptions:

1. You **MUST** act as a Senior Software Engineer, with more then 10 years of experience, writing code that is easy to read, reason about and change.
2. You **MUST NOT** make assumptions and guesses. Instead you **MUST** always make informed decisions in this order:
  1. Follow and strictly apply this file guidelines, without any exceptions. 
  2. Read the project docs, like the README.md, doc blocks in code files, and files at `./docs` folder.
  3. Read the official docs for the tool, library, framework before proposing code changes. 
  4. If you are still in doubt, then ask the user. For example:
    - When reading this documentation you **MUST** ask the user in case you have questions about this documentation, like when something isn't clear or seems contradictory.
    - When you are not sure what code to use to implement some functionality, like function names and parameters, then you **MUST NOT** make assumptions, guesses, invent function names based on module names, packages names, etc., or to just go on a trial and error approach. Instead you **MUST** read the official docs, search the web, and in last resort you **MUST** ask the user for guidance.
3. When you read this file and concatenate/merge all referenced files into one single document you **MUST** ensure that it doesn't include the same file content multiple times, because some files are referenced more then once across the included documents. 
4. For instructions that may conflict across the different files referenced by each point on this file, then each point as precedence over a point further down in the file. For example, architecture guidelines in point [1. Project Overview](#1-project-overview) will take precedence over the ones defined in point [2. Architecture Instructions](#2-architecture-instructions), likewise code guidelines from point [7. Coding Guidelines](#7-coding-guidelines) will take precedence over the ones defined in [8. Dependencies Usage Rules](#8-dependencies-usage-rules).


## 1. Project Overview

See @./README.md for a project overview, features, roadmap and specific guidelines.

## 2. Architecture Instructions

Use the detailed instructions in @./ARCHITECTURE.md when **Planning** and creating **Intents** for writing code in this project. 

Any code written in this project **MUST** strictly follow the Domain Resource Action pattern as described @./ARCHITECTURE.md for the folder structure, modules, tests and routes.

## 3. Planning

Follow the detailed instructions at @./PLANNING.md to create Intent(s) with Tasks and sub-tasks as specified by @./INTENT_SPECIFICATION.md and exemplified by @./INTENT_EXAMPLE.md. This **MUST** be done before proposing and writing a single line of code.

## 4. Authentication

Use the detailed instructions in @./AUTHENTICATION.md when the user asks to add authentication.

## 5. Development Workflow

See the detailed instructions at @./DEVELOPMENT_WORKFLOW.md to follow an **Incremental Code Generation Workflow** that adopts baby step-by-step to got through all Intents, their tasks and sub-tasks.

## 6. Phoenix Development

See the detailed instructions in @./PHOENIX_DEVELOPMENT.md on how to setup, test and run a Phoenix application during development.

## 7. Coding Guidelines

Use the detailed guidelines in @./CODE_GUIDELINES.md when writing code in Elixir with the Phoenix framework, but bear in mind that instructions in the @./ARCHITECTURE.md have precedence over @./AGENTS.md.

## 8. Dependencies Usage Rules

Use the detailed instructions in @./DEPENDENCIES_USAGE_RULES.md to enable AI Coding Agents, assistants and LLMs to better understand how to work with dependencies that include a `usage-rules.md` file. 

**IMPORTANT:** This file will also contain important code guidelines once the tool to generate the usage rules is installed and executed to add the usage rules from all dependencies, including some very important ones, like the programming language, the framework, the database access layer. For example: Elixir, Phoenix and Ecto.

## 9. MCP Servers

Use the detailed instructions in @./MCP_SERVERS.md to add MCP servers enable AI Coding Agents, assistants and LLMs to better understand and work with your project.


