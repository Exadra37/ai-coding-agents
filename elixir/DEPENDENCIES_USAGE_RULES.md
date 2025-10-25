# Dependencies Usage Rules

Some Elixir packages are now including an `usage-rules.md` to guide AI coding agents, coding assistants, LLMs on how to use effectively the dependency. The `usage-rules.md` itself isn't an existing standard, instead it is a community initiative.

The Elixir package [`:usage_rules`](https://hexdocs.pm/usage_rules/readme.html) helps to fetch and consolidate all usage rules from dependencies into a file of our choice, that in this case will be this file.

When this file is analyzed for the first time by an AI Coding Agent it **MUST** check `mix.exs` to see if the project is already using the `:usage_rules` dependency, and if not then ask the developer if he wants to use @PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.

Steps to add the usage rules dependency and collect the usage rules into this same file:

1. Add `{:usage_rules, "~> 0.1"}` to the `mix.exs` file.
2. Run `mix deps.get` and `mix deps.compile`.
3. Run `mix usage_rules.sync DEPENDENCIES_USAGE_RULES.md --all --inline usage_rules:all --link-to-folder deps`

The above steps can be easily translated to tasks and sub-task when creating an Intent during the planning phase, that **MUST** follow the format of the @INTENT_EXAMPLE.md.

## Usage Rules

To be added by the AI coding agent or by the developer by running `mix usage_rules.sync DEPENDENCIES_USAGE_RULES.md --all --inline usage_rules:all --link-to-folder deps`.
