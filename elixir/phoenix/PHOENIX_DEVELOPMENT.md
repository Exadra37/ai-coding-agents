# Phoenix Development

This file's goal is to instruct AI Coding Agents on how to setup, test and run a Phoenix application during development.

**IMPORTANT:** This is a Phoenix 1.8 project using DaisyUI on top of TailwindCSS, except for using DaisyUI components and `@apply` as recommended in the CODE_GUIDELINES markdown documentation. This means that the default for this project is to write custom Tailwind CSS components instead of using DaisyUI components and `@apply`, unless the README opts-in to use DaisyUI components and/or `@apply` for the entire project or the opt-in is done in a per-Intent basis. To be crystal clear these aren't conflicting instructions and guidance between this file and CODE_GUIDELINES file.

**IMPORTANT:** Regarding the Heroicons guidelines in CODE_GUIDELINES.md they mean that you **MUST** always use Heroicons via the `<.icon ...>` Phoenix core components, not via `<Heroicons ...>`, so this is explicit guidance, therefore it's not conflicting or contradictory instructions.

## 1. Setup 

Required before starting the Phoenix server for the first time:

* Run `mix setup` to install and setup dependencies, assets and database.

## 2. Phoenix Server

To start the Phoenix server in development:

* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## 3. Mix Tests

* Run `mix test` to run the entire test suite of tests.
* Run `mix test /path/to/file_tests.exs` to test a single file.
* Run `mix test /path/to/file_tests.exs:line_number` to test a single test in a file by line number. 
* Run `MIX_ENV=test mix ecto.reset` when database or migrations seem to be corrupt or misbehaving. This can occur when switching between git branches with different database migrations.

## 4. Mix Available Tools

* Run `mix help` to find all available tools and aliases.
* Run `mix help <tool_or_alias>` to get help for them.

## 5. Elixir and Phoenix Documentation

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
