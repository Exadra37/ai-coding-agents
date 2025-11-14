# AI Intent Driven Development (IDD)

[![Github Sponsor: https://github.com/sponsors/Exadra37](/assets/svg/github-sponsor.svg)](https://github.com/sponsors/Exadra37)

The main goal of this project is to provide **AI Intent Driven Development (IDD)** guidance for AI Coding Agents, AI Coding Assistants, and LLMs.

An Intent is a self-contained document that describes a user request. It is composed of three main sections: **WHY** (the motivation), **WHAT** (the requirements, often in Gherkin language), and **HOW** (a detailed, step-by-step implementation plan defined with tasks). This approach ensures clarity and alignment before any code is written.

This project delivers this guidance as a collection of markdown files that instruct AI agents to follow specific guidelines for planning and creating Intents from user requests, with additional instructions on architecture, development workflow, code guidelines and more. It supports both language-agnostic and language-specific guidance. Currently, the project focuses on Elixir and Phoenix, with plans to support other BEAM languages and frameworks in the near future. Other programming languages and frameworks will also be supported.

## TOC

* [Overview](#overview)
* [How to Install](#how-to-install)
  * [Linux](#linux)
* [How to Setup](#how-to-setup)
  * [New Agent File From Scratch](#new-agent-file-from-scratch)
  * [Add to Existing Agent File](#add-to-existing-agent-file)
  * [Copy as Individual Markdown Files](#copy-as-individual-markdown-files)
* [How to Use with AI Coding Agents](#how-to-use-with-ai-coding-agents)
  * [Prompts](#prompts)
* [How to Contribute](#how-to-contribute)
  * [Guidelines](#guidelines)
  * [Development](#development)
  * [Testing](#testing)
* [Credits](#credits)


## Overview

These project guidelines are split into several files that can be combined into a single agent file when installing.

Current individual markdown files for guidelines:

* [AGENTS.md](/AGENTS.md).
* [INTENT_SPECIFICATION.md](/INTENT_SPECIFICATION.md).
* [INTENT_EXAMPLE.md](/INTENT_EXAMPLE.md).
* [PLANNING.md](/PLANNING.md)
* [DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md](/elixir/phoenix/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md)
* [DEVELOPMENT_WORKFLOW.md](/DEVELOPMENT_WORKFLOW.md)
* [PHOENIX_DEVELOPMENT.md](/elixir/phoenix/PHOENIX_DEVELOPMENT.md)
* [CODE_GUIDELINES.md](/elixir/CODE_GUIDELINES.md)
* [DEPENDENCIES_USAGE_RULES.md](/elixir/DEPENDENCIES_USAGE_RULES.md)
* [AUTHENTICATION.md](/elixir/phoenix/AUTHENTICATION.md)
* [MCP_SERVERS.md](/elixir/MCP_SERVERS.md)

The project defines a Domain Resource Action architecture pattern. This pattern organizes the business logic into a clear structure of Domains, Resources, and Actions. Each Action is a self-contained module that handles a single responsibility, making the code easier to understand, reason about, test, maintain, add features and fix bugs. This architecture is designed to work with Phoenix code generators and provides a clear path for refactoring generated code into a more robust structure. This architecture is easily applied to any programming language and framework, and will do so in the future. While strongly recommended to be used, you can drop it, by removing it from the agent file or deleting the ARCHITECTURE.md file, depending how you installed the guidelines.

[Back to TOC](#toc)

## How to Install

For all operating systems we recommend you to clone this repo to the usual place where installed applications go. For example in Linux this repo could be installed at `~/.local/share/ai-intent-driven-development`.

### Linux

We recommend you to perform a global installation, but we also provide instructions for project specific installation.

On your terminal execute:

```shell
git clone https://github.com/Exadra37/ai-intent-driven-development.git ~/.local/share/ai-intent-driven-development
```

Go inside the installation directory:

```shell
cd ~/.local/share/ai-intent-driven-development
```

Add the `bin` folder to your path permanently in `~/.bashrc`, `~/.zshrc` or the file for your shell of preference.

For `~/.bashrc`:

```shell
echo 'export AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR=~/.local/share/ai-intent-driven-development' >> ~/.bashrc
echo 'export PATH=$PATH:${AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR}/bin' >> ~/.bashrc
echo 'alias aidd="${AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR}/bin/ai-intent-driven-development.sh"' >> ~/.zshrc
```

For `~/.zshrc`:

```shell
echo 'export AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR=~/.local/share/ai-intent-driven-development' >> ~/.zshrc
echo 'export PATH=$PATH:${AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR}/bin' >> ~/.zshrc
echo 'alias aidd="${AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR}/bin/ai-intent-driven-development.sh"' >> ~/.zshrc
```

> **IMPORTANT:** The environment variable `AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR` is required for the script to work properly.

Now, you need to reload your shell file:

```shell
source ~/.bashrc
```

> **NOTE:** Replace `~/.bashrc` with the file for your shell, for example `~/.zshrc`.

Check help with:

```shell
ai-intent-driven-development.sh help
```

Or with:

```shell
aidd help
```

#### Project Specific Installation

On your terminal execute:

```shell
mkdir .local
git clone https://github.com/Exadra37/ai-intent-driven-development.git .local/ai-intent-driven-development
```

If you don't have a `.gitignore_global` yet, you can create one with:

```shell
echo ".local/" >> ~/.gitignore_global
git config --global core.excludesFile '~/.gitignore_global'
```

Next, add `./bin/ai-intent-driven-development.sh` to your path:

```shell
export PATH="$PATH:$(pwd)/.local/ai-intent-driven-development/bin"
```

Or add an alias for your current shell if you prefer a shorter name:

```shell
alias aidd=".local/ai-intent-driven-development/bin/ai-intent-driven-development.sh"
```

> NOTE: Both are only valid for your current shell session.

Check help with:

```shell
ai-intent-driven-development.sh help
```

Or with:

```shell
aidd help
```

[Back to TOC](#toc)

## How to Setup

Follow the steps below to use these project guidelines for AI Coding Agents, AI Coding Assistants, LLMs, or whatever name is being used nowadays or you are more familiar with.

### New Agent File From Scratch

For language agnostic guidelines to the default `AGENTS.md` file:

```shell
ai-intent-driven-development.sh from-scratch
```

For language agnostic guidelines to a specific agents file:

```shell
ai-intent-driven-development.sh from-scratch CLAUDE.md
```

For Elixir guidelines to the default `AGENTS.md` file:

```shell
ai-intent-driven-development.sh from-scratch elixir
```

For Elixir guidelines to a specific agent file:

```shell
ai-intent-driven-development.sh from-scratch CLAUDE.md elixir
```

For Elixir and Phoenix guidelines to a specific agent file:

```shell
ai-intent-driven-development.sh from-scratch CLAUDE.md elixir phoenix
```

### Add to Existing Agent File

For language agnostic guidelines to the default `AGENTS.md` file:

```shell
ai-intent-driven-development.sh add
```

For language agnostic guidelines to a specific agents file:

```shell
ai-intent-driven-development.sh add CLAUDE.md
```

For Elixir guidelines to the default `AGENTS.md` file:

```shell
ai-intent-driven-development.sh add elixir
```

For Elixir guidelines to a specific agent file:

```shell
ai-intent-driven-development.sh add CLAUDE.md elixir
```

For Elixir and Phoenix guidelines to a specific agent file:

```shell
ai-intent-driven-development.sh add CLAUDE.md elixir phoenix
```

### Copy as Individual Markdown Files

For language agnostic guidelines:

```shell
ai-intent-driven-development.sh copy
```

For Elixir guidelines:

```shell
ai-intent-driven-development.sh copy elixir
```

For Elixir and Phoenix guidelines:

```shell
ai-intent-driven-development.sh copy elixir phoenix
```

[Back to TOC](#toc)

## How to Use with AI Coding Agents

You **MUST** start a new session with your AI Coding agent, assistant, LLM when adding this collection of guidelines to your project to ensure the agent picks up the new `AGENTS.md` file or whatever one you used, like `CLAUDE.md`, `GEMINI.md`, and others.

### Prompts

#### For the first time

To ensure that the AI is on the same page as you, we strongly recommend to execute the below prompts when starting a session or at least when you install these guidelines.

First, start by instructing the AI to read the Agents file:

```text
Read the @AGENTS.md in full and also read in full all the documents it links to, and do the same for links included in any of these files.
Make sure you understand every bit on them, otherwise we will waste our time when working together, because we will not have the same understanding of whats in the documentation.
```

After the AI says it has read it, ensure it has understood everything:

```text
Do you have questions about the documentation? Anything that's not clear to you? Don't make assumptions.
```

Next, ask it for a summary:

```text
Can you summarize the documentation in a few points?
```

> **TIP:** After running one of these prompts, especially for when it answers the second prompt, where it may be a lot of in the answer and/or asks for clarifications/confirmations in things that are already clearly/explicitly explained in the documents, and/or it misunderstands the documents it was asked to read and grasp, then it's better that you start another session, because it was a bad/false start. If you believe that any of the documents can be improved to avoid any of it, then open a discussion with the prompts and the answers with your proposed improvements to be discussed.

#### Planning an Intent to work on your project

To work on a new feature, fix, or whatever you want, then you need to prompt the AI Agent with some context about what you plan to work on, and the AI Agent should propose to you the creation of an Intent after discussing it with you.

For example:

```text
I want to work on a feature to add support for a Newsletter, including user subscription and management without using a third-party provider, content creation with modern HTML templates, and sending it via email providers.
Before proposing the Intent with the tasks, ask questions, propose solutions, to be discussed to establish an implementation plan to be then translated into an Intent, that will explain WHY, WHAT and HOW (the tasks).
```

> **NOTE:** If using Claude then you may want to use the planning mode for better results.

After you have an Intent, it should resemble [this example](/examples/intents/todo/10_feature_cms-articles_add-crud-actions-with-markdown-real-time-editor.md).


#### Executing all Intent Tasks

Now that you have an Intent you simply point the AI Coding Agent at it and it will start working on each task on it, one at a time.


```text
Start working on Intent 10.
```

or

```text
Resume work on Intent 10.
```

[Back to TOC](#toc)

## How to Contribute

### Guidelines

Before contributing, please open a [new discussion](https://github.com/Exadra37/ai-intent-driven-development/discussions/new?category=ideas) to propose your changes and ensure they align with the project's goals.

If you make changes to `/bin` then they need to come with tests for all scenarios.

### Development

To contribute to this project, you first need to clone the repository:

```shell
git clone git@github.com:Exadra37/ai-intent-driven-development.git
```

Once you have cloned the repository, you need to initialize the submodules:

```shell
cd ai-intent-driven-development
git submodule update --init --recursive
```

Then follow the instructions to add the bash script of this project to the path for your operating system at [How to Install](#how-to-install).

### Testing

This project uses [Bats-Core](https://github.com/bats-core/bats-core) for testing. Test files are located in the `test/` directory.

To run the tests, first make sure you have initialized the submodules as described in the Development section. Then, execute the following command:

```shell
test/libs/bats-core/bin/bats test/ai-intent-driven-development.sh.bats
```

[Back to TOC](#toc)


## Credits

This repo was inspired by bits and bobs from here and there on the web, with some sprinkles of my own.

Some of the more influential sources for my work:

* [Intent Steel Thread](https://github.com/matthewsinclair/intent) - Inspired on this concept for the WHY. WHAT, HOW, and Tasks, but condensed in one single document, the Intent.
* [Kevin Hoffman](https://www.linkedin.com/in/kevinshoffman/) - The development workflow guidelines are inspired by the ones they use at Akka.
* [Phoenix Framework](https://phoenixframework.org/) - The code guidelines for Elixir is a copy from the AGENTS.md file generated by `mix phx.new`.

[Back to TOC](#toc)
