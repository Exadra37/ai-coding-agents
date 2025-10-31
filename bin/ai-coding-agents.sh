  #!/bin/sh

set -eu

Help() {
  echo ""
  echo "Usage: ./ai-coding-agents.sh [command] [optional_agent_file]"
  echo ""
  echo "This script helps to set up the AGENTS.md file for the AI coding agent."
  echo "The default is the AGENTS.md file that you can override to suite your needs."
  echo ""
  echo "Examples:"
  echo "  $ ./ai-coding-agents.sh add"
  echo "  $ ./ai-coding-agents.sh add CLAUDE.md"
  echo ""
  echo "Commands:"
  echo "  from-scratch [agent_file]    Creates the agent file from scratch, removing the existing one."
  echo "                               Defaults to AGENTS.md if no file is provided."
  echo "  add [agent_file]             Appends the content of all individual markdown files to the agent file."
  echo "                               Defaults to AGENTS.md if no file is provided."
  echo "  copy                         Copies all the individual markdown files to the current directory."
  echo "  help                         Displays this help message."
  echo ""
  echo "The script will check for a clean git repository before running 'from-scratch', 'add', or 'copy'."
  echo "If the repository has uncommitted changes, the script will exit, and ask you to commit them."
  echo "If the directory is not a git repository, it will back up the existing agent file before proceeding."
  echo ""
}

Abort_If_Dirty_Git() {
  local _agent_file="${1:-${AGENT_FILE}}"

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "---> This is not a git repository."
    echo "---> We will backup your agent file: ${_agent_file}"

    Backup_Agent_File "${@}"
  fi

  # The `git status --porcelain` command returns an empty string
  # if the working directory is clean (no changes, no new files).
  if [ -z "$(git status --porcelain)" ]; then
    # Clean
    return 0
  else
    # Dirty (has changes)
    echo "---> The git repository has uncommitted changes."
    echo "---> Please commit your changes and try again."
    return 1
  fi
}

Backup_Agent_File() {
  local _agent_file="${1:-${AGENT_FILE}}"

  if [ -f "${_agent_file}" ]; then
    cp "${_agent_file}" "${_agent_file}.$(date +%s)"
  fi
}

From_Scratch() {
  local _agent_file="${1:-${AGENT_FILE}}"

  if [ -f "${_agent_file}" ]; then
    rm "${_agent_file}"
  fi

  Add_All "${@}"
}

Add_All() {
  local _agent_file="${1:-${AGENT_FILE}}"

  echo -e "<!-- ai_agents:usage_rules:start -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:instructions_overview:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/AGENTS.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:instructions_overview:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:architecture:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:architecture:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:planning:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/PLANNING.md >> "${_agent_file}"
  echo -e "\n<!-- ai_agents:planning:intent_specification:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/INTENT_SPECIFICATION.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:intent_specification:end -->" >> "${_agent_file}"
  echo -e "\n<!-- ai_agents:planning:intent_example:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/INTENT_EXAMPLE.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:intent_example:end -->" >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:development_workflow:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/DEVELOPMENT_WORKFLOW.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:development_workflow:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:phoenix_development:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/PHOENIX_DEVELOPMENT.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:phoenix_development:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:authentication:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/AUTHENTICATION.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:authentication:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:code_guidelines:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/CODE_GUIDELINES.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:code_guidelines:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:dependencies_usage_rules:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/DEPENDENCIES_USAGE_RULES.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:dependencies_usage_rules:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:mcp_servers:start -->" >> "${_agent_file}"
  cat ${INSTALL_DIR}/ai-coding-agents/elixir/MCP_SERVERS.md >> "${_agent_file}"
  echo -e "<!-- ai_agents:mcp_servers:end -->" >> "${_agent_file}"

  echo -e "\n<!-- usage-rules-end -->" >> "${_agent_file}"

  # When reading the AGENTS.md file the AI agent will treat anything that starts by `@` as filename to include.
  # We want that references to files like `@./ARCHITECTURE.md` become `ARCHITECTURE documentation`.
  sed -i 's|@./||g; s/\.md\b/ documentation/g' "${_agent_file}"
}

Copy_All() {
  cp ${INSTALL_DIR}/ai-coding-agents/AGENTS.md .
  cp ${INSTALL_DIR}/ai-coding-agents/DEVELOPMENT_WORKFLOW.md .
  cp ${INSTALL_DIR}/ai-coding-agents/PLANNING.md .
  cp ${INSTALL_DIR}/ai-coding-agents/INTENT_SPECIFICATION.md .
  cp ${INSTALL_DIR}/ai-coding-agents/INTENT_EXAMPLE.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/MCP_SERVERS.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/CODE_GUIDELINES.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/DEPENDENCIES_USAGE_RULES.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/PHOENIX_DEVELOPMENT.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/AUTHENTICATION.md .
  cp ${INSTALL_DIR}/ai-coding-agents/elixir/phoenix/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md ARCHITECTURE.md
}

Main() {

  local INSTALL_DIR="${AI_CODING_AGENTS_INSTALL_DIR:-~/.local/bin/share/ai-coding-agents}"

  local AGENT_FILE="${AI_CODING_AGENTS_FILE:-AGENTS.md}"

  if [ $# -eq 0 ]; then
    Help
    exit 0
  fi

  for argument in "${@}"; do
    case "${argument}" in

      from-scratch )
        shift 1

        Abort_If_Dirty_Git "${@}"

        From_Scratch "${@}"

        exit $?
        ;;

      add )
        shift 1

        Abort_If_Dirty_Git "${@}"

        Add_All "${@}"

        exit $?
      ;;

      copy )
        shift 1

        Abort_If_Dirty_Git "${@}"

        Copy_All

        exit $?
      ;;

      help )
        Help

        exit 0
      ;;

      * )
        echo ""
        echo "UNKNOWN COMMAND: ${argument}"

        Help

        exit 1
      ;;

    esac
  done
}

Main "${@}"
