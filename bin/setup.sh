#!/bin/sh

set -eu

Main() {

  local AI_CODING_AGENTS_INSTALL_DIR=./../../../..

  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/AGENTS.md .

  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/DEVELOPMENT_WORKFLOW.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/PLANNING.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/INTENT_SPECIFICATION.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/INTENT_EXAMPLE.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/elixir/MCP_SERVERS.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/elixir/CODE_GUIDELINES.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/elixir/DEPENDENCIES_USAGE_RULES.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/elixir/phoenix/PHOENIX_DEVELOPMENT.md .
  cp ${AI_CODING_AGENTS_INSTALL_DIR}/ai-coding-agents/elixir/phoenix/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md ARCHITECTURE.md

}

Main "${@}"
