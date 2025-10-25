# AGENTS

This file provides guidance to AI coding agents, AI assistants and LLMs when working with code in this repository.

**CRITICAL:** In case of questions about the documentation, something isn't clear or seems contradictory then you **MUST** not make guesses and/or assumptions, instead you need to ask the user for clarification, before proceeding to the next step.

**IMPORTANT:** For instructions that may conflict across the different files referenced by each point on this file, then each point as precedence over a point further down in the file. For example, architecture guidelines in point **1. Project Overview** will take precedence over the ones defined in point **3. Architecture Instructions**, likewise code guidelines from point **4. Coding Guidelines** will take precedence over the ones defined in **5. Dependencies Usage Rules**.

**ALERT:** When an AI coding agent, assistant or LLM reads this file and tries to concatenate/merge all referenced files into one single document it **MUST** ensure that it doesn't include the same file twice, because some files are referenced more then once across the included documents. 

## 1. Project Overview

See @README.md for a project overview, features, roadmap and specific guidelines.

## 2. Planning

Follow the detailed instructions at @PLANNING.md to create Intent(s) with Tasks and sub-tasks before propose and writing a single line of code.

## 3. Architecture Instructions

Use the detailed instructions in @ARCHITECTURE.md when writing code in this project, which **MUST** follow strictly the Domain Resource Action pattern as described there for the folder structure, modules and routes.

## 4. Coding Guidelines

Use the detailed guidelines in @CODE_GUIDELINES.md when writing code in Elixir with the Phoenix framework, but bear in mind that instructions in the @ARCHITECTURE.md have precedence over @AGENTS.md.

## 5. Dependencies Usage Rules

Use the detailed instructions in @DEPENDENCIES_USAGE_RULES.md to enable AI Coding Agents, assistants and LLMs to better understand how to work with dependencies that include a `usage-rules.md` file. 

**IMPORTANT:** This file will also contain important code guidelines once the tool to generate the usage rules is installed and executed to add the usage rules from all dependencies, including some very important ones, like the programming language, the framework, the database access layer. For example: Elixir, Phoenix and Ecto.

## 6. MCP Servers

Use the detailed instructions in @MCP_SERVERS.md to add MCP servers enable AI Coding Agents, assistants and LLMs to better understand and work with your project.

## 7. Phoenix Development

See the detailed instructions in @PHOENIX_DEVELOPMENT.md on how to setup, test and run a Phoenix application during development.

## 8. Development Workflow

See the detailed instructions at @DEVELOPMENT_WORKFLOW.md to follow an **Incremental Code Generation Workflow** that adopts baby step-by-step to got through all Intents, their tasks and sub-tasks.
