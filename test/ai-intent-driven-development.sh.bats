#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

setup() {
  # Create a main temporary directory for the test run.
  BATS_TMPDIR="$(mktemp -d -t bats-test-XXXXXX)"

  # Define the path for our isolated project clone.
  PROJECT_COPY_TEST_DIR="${BATS_TMPDIR}/ai-intent-driven-development-copy-for-test"

  # Copy the current state of the repository to the clone directory.
  cp -r "$PWD/" "$PROJECT_COPY_TEST_DIR"

  # Set the INSTALL_DIR to our new clone. The script will use this as its root.
  export AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR="$PROJECT_COPY_TEST_DIR"

  # Define the path to the script we will be testing.
  SCRIPT_PATH="${PROJECT_COPY_TEST_DIR}/bin/ai-intent-driven-development.sh"

  # `cd` into a separate "working" directory for the test to run commands in.
  mkdir "${BATS_TMPDIR}/workspace"
  cd "${BATS_TMPDIR}/workspace"

  # Initialize this working directory as a git repo so the script's checks pass.
  git init &> /dev/null
  git config user.email "test@example.com" &> /dev/null
  git config user.name "Test" &> /dev/null
  git commit --allow-empty -m "initial commit" &> /dev/null
}

teardown() {
  rm -rf "${BATS_TMPDIR}"
}

# --- Test Edge Cases ---

@test "script shows help" {
  run "$SCRIPT_PATH" help
  assert_success
  assert_output --partial "Usage:"
}

@test "from-scratch command fails on dirty git repo" {
  echo "dirty" > dirty_file.txt
  run "$SCRIPT_PATH" from-scratch
  assert_failure
  assert_output --partial "The git repository has uncommitted changes."
}

@test "from-scratch command in non-git repo creates backup" {
  # Create a temporary directory that is not a git repository
  local non_git_dir
  non_git_dir=$(mktemp -d)
  cd "$non_git_dir"

  echo "old content" > AGENTS.md
  run "$SCRIPT_PATH" from-scratch
  assert_success
  assert_output --partial "This is not a git repository."
  assert_output --partial "We will backup your agent file: AGENTS.md"
  backup_file=$(find . -name "AGENTS.md.*")
  assert [ -f "$backup_file" ]
  run cat "$backup_file"
  assert_output "old content"

  # Cleanup
  rm -rf "$non_git_dir"
}

# --- Test 'from-scratch' Command Permutations ---

@test "from-scratch (elixir and phoenix with framework AGENTS.md)" {
  cd "$PROJECT_COPY_TEST_DIR"
  mkdir -p "elixir/phoenix"
  echo "# FRAMEWORK AGENTS" > "elixir/phoenix/AGENTS.md"
  git add "elixir/phoenix/AGENTS.md"
  git commit -m 'agents file' &> /dev/null
  cd -

  run "$SCRIPT_PATH" from-scratch elixir phoenix
  assert_success
  assert [ -f "AGENTS.md" ]

  run cat AGENTS.md
  assert_output --partial "# FRAMEWORK AGENTS"
}

@test "from-scratch (elixir with language AGENTS.md)" {
  cd "$PROJECT_COPY_TEST_DIR"
  mkdir -p "elixir"
  echo "# LANGUAGE AGENTS" > "elixir/AGENTS.md"
  git add "elixir/AGENTS.md"
  git commit -m 'agents file' &> /dev/null
  cd -

  run "$SCRIPT_PATH" from-scratch elixir
  assert_success
  assert [ -f "AGENTS.md" ]

  run cat AGENTS.md
  assert_output --partial "# LANGUAGE AGENTS"
}

@test "from-scratch (agnostic)" {
  run "$SCRIPT_PATH" from-scratch
  assert_success
  assert [ -f "AGENTS.md" ]
  run cat AGENTS.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  refute_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  refute_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  refute_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "from-scratch (agnostic - custom agents existing file)" {
  echo "# AGENTS" > CLAUDE.md
  git add CLAUDE.md
  git commit -m 'custom agent file' &> /dev/null

  run "$SCRIPT_PATH" from-scratch CLAUDE.md
  assert_success
  assert [ -f "CLAUDE.md" ]
  run cat CLAUDE.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  refute_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  refute_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  refute_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "from-scratch (elixir only)" {
  run "$SCRIPT_PATH" from-scratch elixir
  assert_success
  assert [ -f "AGENTS.md" ]
  run cat AGENTS.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "from-scratch (custom agents existing file with elixir only)" {
  echo "# AGENTS" > CLAUDE.md
  git add CLAUDE.md
  git commit -m 'custom agent file' &> /dev/null

  run "$SCRIPT_PATH" from-scratch CLAUDE.md elixir
  assert_success
  assert [ -f "CLAUDE.md" ]
  run cat CLAUDE.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "from-scratch (elixir and phoenix)" {
  run "$SCRIPT_PATH" from-scratch elixir phoenix
  assert_success
  assert [ -f "AGENTS.md" ]
  run cat AGENTS.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  assert_output --partial "# Authentication"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  assert_output --partial "# Domain Resource Action Architecture"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
  assert_output --partial "# Phoenix Development"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:end -->"
}

@test "from-scratch (custom agents existing file with elixir and phoenix)" {
  echo "# AGENTS" > CLAUDE.md
  git add CLAUDE.md
  git commit -m 'custom agents file' &> /dev/null

  run "$SCRIPT_PATH" from-scratch CLAUDE.md elixir phoenix
  assert_success
  assert [ -f "CLAUDE.md" ]
  run cat CLAUDE.md

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  assert_output --partial "# Authentication"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  assert_output --partial "# Domain Resource Action Architecture"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
  assert_output --partial "# Phoenix Development"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:end -->"
}

# --- Test 'add' Command ---

@test "add (agnostic)" {
  echo "EXISTING CONTENT" > AGENTS.md
  git add AGENTS.md
  git commit -m "add agents file" &> /dev/null

  run "$SCRIPT_PATH" add
  assert_success
  run cat AGENTS.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  refute_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  refute_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  refute_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "add (agnostic - custom agents existing file)" {
  echo "EXISTING CONTENT" > CLAUDE.md
  git add CLAUDE.md
  git commit -m "add custom agents file" &> /dev/null

  run "$SCRIPT_PATH" add CLAUDE.md
  assert_success
  run cat CLAUDE.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  refute_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  refute_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  refute_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "add (elixir only)" {
  echo "EXISTING CONTENT" > AGENTS.md
  git add AGENTS.md
  git commit -m "add agents file" &> /dev/null

  run "$SCRIPT_PATH" add elixir
  assert_success
  run cat AGENTS.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "add (custom agents existing file with elixir only)" {
  echo "EXISTING CONTENT" > CLAUDE.md
  git add CLAUDE.md
  git commit -m "add agents file" &> /dev/null

  run "$SCRIPT_PATH" add CLAUDE.md elixir
  assert_success
  run cat CLAUDE.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  refute_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  refute_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
}

@test "add (elixir and phoenix)" {
  echo "EXISTING CONTENT" > AGENTS.md
  git add AGENTS.md
  git commit -m "add agents file" &> /dev/null

  run "$SCRIPT_PATH" add elixir phoenix
  assert_success
  run cat AGENTS.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  assert_output --partial "# Authentication"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  assert_output --partial "# Domain Resource Action Architecture"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
  assert_output --partial "# Phoenix Development"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:end -->"
}

@test "add (custom agents existing file with elixir and phoenix)" {
  echo "EXISTING CONTENT" > CLAUDE.md
  git add CLAUDE.md
  git commit -m "add agents file" &> /dev/null

  run "$SCRIPT_PATH" add CLAUDE.md elixir phoenix
  assert_success
  run cat CLAUDE.md

  assert_output --partial "EXISTING CONTENT"

  assert_output --partial "<!-- ai_agents:instructions_overview:start -->"
  assert_output --partial "# AGENTS"
  assert_output --partial "<!-- ai_agents:instructions_overview:end -->"

  assert_output --partial "<!-- ai_agents:planning:start -->"
  assert_output --partial "# Planning"
  assert_output --partial "<!-- ai_agents:planning:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_specification:start -->"
  assert_output --partial "# Intent Specification"
  assert_output --partial "<!-- ai_agents:planning:intent_specification:end -->"

  assert_output --partial "<!-- ai_agents:planning:intent_example:start -->"
  assert_output --partial "# 54 - Feature (Catalogs-Products): Add CRUD actions"
  assert_output --partial "<!-- ai_agents:planning:intent_example:end -->"

  assert_output --partial "<!-- ai_agents:development_workflow:start -->"
  assert_output --partial "# Development Workflow"
  assert_output --partial "<!-- ai_agents:development_workflow:end -->"

  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:start -->"
  assert_output --partial "# Code Guidelines"
  assert_output --partial "<!-- ai_agents:elixir:code_guidelines:end -->"

  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:start -->"
  assert_output --partial "# Dependencies Usage Rules"
  assert_output --partial "<!-- ai_agents:elixir:dependencies_usage_rules:end -->"

  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:start -->"
  assert_output --partial "# MCP Servers"
  assert_output --partial "<!-- ai_agents:elixir:mcp_servers:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:start -->"
  assert_output --partial "# Authentication"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:authentication:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:start -->"
  assert_output --partial "# Domain Resource Action Architecture"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:architecture:end -->"

  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:start -->"
  assert_output --partial "# Phoenix Development"
  assert_output --partial "<!-- ai_agents:elixir:phoenix:phoenix_development:end -->"
}

# --- Test 'copy' Command Permutations ---

@test "copy (agnostic)" {
  run "$SCRIPT_PATH" copy
  assert_success
  assert [ -f "AGENTS.md" ]
  assert [ -f "PLANNING.md" ]
  assert [ -f "INTENT_SPECIFICATION.md" ]
  assert [ -f "INTENT_EXAMPLE.md" ]
  assert [ -f "DEVELOPMENT_WORKFLOW.md" ]
  refute [ -f "CODE_GUIDELINES.md" ]
  refute [ -f "DEPENDENCIES_USAGE_RULES.md" ]
  refute [ -f "MCP_SERVERS.md" ]
  refute [ -f "AUTHENTICATION.md" ]
  refute [ -f "ARCHITECTURE.md" ]
  refute [ -f "PHOENIX_DEVELOPMENT.md" ]
}

@test "copy (elixir only)" {
  run "$SCRIPT_PATH" copy elixir
  assert_success
  assert [ -f "AGENTS.md" ]
  assert [ -f "PLANNING.md" ]
  assert [ -f "INTENT_SPECIFICATION.md" ]
  assert [ -f "INTENT_EXAMPLE.md" ]
  assert [ -f "DEVELOPMENT_WORKFLOW.md" ]
  assert [ -f "CODE_GUIDELINES.md" ]
  assert [ -f "DEPENDENCIES_USAGE_RULES.md" ]
  assert [ -f "MCP_SERVERS.md" ]
  refute [ -f "AUTHENTICATION.md" ]
  refute [ -f "ARCHITECTURE.md" ]
  refute [ -f "PHOENIX_DEVELOPMENT.md" ]
}

@test "copy (elixir and phoenix)" {
  run "$SCRIPT_PATH" copy elixir phoenix
  assert_success
  assert [ -f "AGENTS.md" ]
  assert [ -f "PLANNING.md" ]
  assert [ -f "INTENT_SPECIFICATION.md" ]
  assert [ -f "INTENT_EXAMPLE.md" ]
  assert [ -f "DEVELOPMENT_WORKFLOW.md" ]
  assert [ -f "CODE_GUIDELINES.md" ]
  assert [ -f "DEPENDENCIES_USAGE_RULES.md" ]
  assert [ -f "MCP_SERVERS.md" ]
  assert [ -f "AUTHENTICATION.md" ]
  assert [ -f "ARCHITECTURE.md" ]
  assert [ -f "PHOENIX_DEVELOPMENT.md" ]
}
