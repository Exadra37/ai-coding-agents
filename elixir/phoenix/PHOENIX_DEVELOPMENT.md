# Phoenix Development

This file goal is to instruct AI Coding Agents on how to setup, test and run a Phoenix application during development.

## 1. Setup 

Required before starting the Phoenix server for the first time:

* Run `mix setup` to install, setup dependencies, assets and database.

Since Phoenix 1.8 also uses DaisyUI on top of TailwindCSS, therefore some differences exist on how things work now. Refer to @CODE_GUIDELINES.md for more detailed information on this. While code guidelines advises writing custom Tailwind CSS components instead of using DaisyUI components, and to to not use `@pply`, this doesn't mean that DaisyUI isn't being used in the Phoenix project, just means that this functionalities aren't recommended to be used. Heroicons is also used, but the code guidelines say that they **MUST** be used via the `.icon` Phoenix core components.

## 2. Phoenix Server

To start the Phoenix server in development:

* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## 3. Mix Tests

* Run `mix test` to run the entire test suite of tests.
* Run `mix test /path/to/file_tests.exs` to test a single file.
* Run `mix test /path/to/file_tests.exs:line_number` to test a single test in file by line number. 
* Run `MIX_ENV=test mix ecto.reset` when database or migrations seem to be corrupt or mishbeaving. This can occur when swithcting between git branches with different database migrations.

## 4. Mix Available Tools

* Run `mix help` to find all avaialble tools and aliases.
* Run `mix help <tool_or_alias>` to get help for them.

## 5. Elixir and Phoenix Documentation

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
