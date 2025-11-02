#!/bin/sh

set -eu

Help() {
  echo ""
  echo "Usage: ai-intent-driven-development.sh [command] [optional_agent_file] [optional_language] [optional_framework]"
  echo ""
  echo "This script helps to set up the AGENTS.md file for the AI coding agent."
  echo "The default is the AGENTS.md file that you can override to suite your needs."
  echo ""
  echo "Examples:"
  echo "  $ ai-intent-driven-development.sh add"
  echo "  $ ai-intent-driven-development.sh add CLAUDE.md"
  echo "  $ ai-intent-driven-development.sh add elixir"
  echo "  $ ai-intent-driven-development.sh add elixir phoenix"
  echo "  $ ai-intent-driven-development.sh add CLAUDE.md elixir phoenix"
  echo ""
  echo "Commands:"
  echo "  from-scratch [agent] [lang] [framework]    Creates the agent file from scratch, removing the existing one."
  echo "                                             Defaults to AGENTS.md if no file is provided."
  echo "  add [agent] [lang] [framework]             Appends the content of all individual markdown files to the agent file."
  echo "                                             Defaults to AGENTS.md if no file is provided."
  echo "  copy [lang] [framework]                    Copies all the individual markdown files to the current directory."
  echo "  help                                       Displays this help message."
  echo ""
  echo "The script will check for a clean git repository before running 'from-scratch', 'add', or 'copy'."
  echo "If the repository has uncommitted changes, the script will exit, and ask you to commit them."
  echo "If the directory is not a git repository, it will back up the existing agent file before proceeding."
  echo ""
}

Abort_If_Dirty_Git() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "---> This is not a git repository."
    echo "---> We will backup your agent file: ${AGENT_FILE}"

    Backup_Agent_File "${AGENT_FILE}"
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
    exit 1
  fi
}

Backup_Agent_File() {
  local _agent_file="${1}"

  if [ -f "${_agent_file}" ]; then
    cp "${_agent_file}" "${_agent_file}.$(date +%s)"
  fi
}

From_Scratch() {
  local _agent_file="${1}"
  local _language="${2}"
  local _framework="${3}"

  if [ -f "${_agent_file}" ]; then
    rm "${_agent_file}"
    touch "${_agent_file}"
  fi

  Add_All "${@}"
}

Add_All() {
  local _agent_file="${1}"
  local _language="${2}"
  local _framework="${3}"

  echo "<!-- ai_agents:usage_rules:start -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:instructions_overview:start -->" >> "${_agent_file}"
  cat "${INSTALL_DIR}/AGENTS.md" >> "${_agent_file}"
  echo -e "<!-- ai_agents:instructions_overview:end -->" >> "${_agent_file}"

  if [ -n "${_framework}" ] && [ -f "${INSTALL_DIR}/${_language}/${_framework}/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md" ]; then
      echo -e "\n<!-- ai_agents:${_language}:${_framework}:architecture:start -->" >> "${_agent_file}"
      cat "${INSTALL_DIR}/${_language}/${_framework}/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md" >> "${_agent_file}"
      echo -e "<!-- ai_agents:${_language}:${_framework}:architecture:end -->" >> "${_agent_file}"
  fi

  echo -e "\n<!-- ai_agents:planning:start -->" >> "${_agent_file}"
  cat "${INSTALL_DIR}/PLANNING.md" >> "${_agent_file}"
  echo -e "\n<!-- ai_agents:planning:intent_specification:start -->" >> "${_agent_file}"
  cat "${INSTALL_DIR}/INTENT_SPECIFICATION.md" >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:intent_specification:end -->" >> "${_agent_file}"
  echo -e "\n<!-- ai_agents:planning:intent_example:start -->" >> "${_agent_file}"
  cat "${INSTALL_DIR}/INTENT_EXAMPLE.md" >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:intent_example:end -->" >> "${_agent_file}"
  echo -e "<!-- ai_agents:planning:end -->" >> "${_agent_file}"

  echo -e "\n<!-- ai_agents:development_workflow:start -->" >> "${_agent_file}"
  cat "${INSTALL_DIR}/DEVELOPMENT_WORKFLOW.md" >> "${_agent_file}"
  echo -e "<!-- ai_agents:development_workflow:end -->" >> "${_agent_file}"

  if [ -n "${_framework}" ]; then
    _framework_upper=$(echo "${_framework}" | tr '[:lower:]' '[:upper:]')
    _dev_file="${INSTALL_DIR}/${_language}/${_framework}/${_framework_upper}_DEVELOPMENT.md"
    if [ -f "${_dev_file}" ]; then
        echo -e "\n<!-- ai_agents:${_language}:${_framework}:${_framework}_development:start -->" >> "${_agent_file}"
        cat "${_dev_file}" >> "${_agent_file}"
        echo -e "<!-- ai_agents:${_language}:${_framework}:${_framework}_development:end -->" >> "${_agent_file}"
    fi
  fi

  if [ -n "${_framework}" ] && [ -f "${INSTALL_DIR}/${_language}/${_framework}/AUTHENTICATION.md" ]; then
      echo -e "\n<!-- ai_agents:${_language}:${_framework}:authentication:start -->" >> "${_agent_file}"
      cat "${INSTALL_DIR}/${_language}/${_framework}/AUTHENTICATION.md" >> "${_agent_file}"
      echo -e "<!-- ai_agents:${_language}:${_framework}:authentication:end -->" >> "${_agent_file}"
  fi

  if [ -n "${_language}" ] && [ -f "${INSTALL_DIR}/${_language}/CODE_GUIDELINES.md" ]; then
      echo -e "\n<!-- ai_agents:${_language}:code_guidelines:start -->" >> "${_agent_file}"
      cat "${INSTALL_DIR}/${_language}/CODE_GUIDELINES.md" >> "${_agent_file}"
      echo -e "<!-- ai_agents:${_language}:code_guidelines:end -->" >> "${_agent_file}"
  fi

  if [ -n "${_language}" ] && [ -f "${INSTALL_DIR}/${_language}/DEPENDENCIES_USAGE_RULES.md" ]; then
      echo -e "\n<!-- ai_agents:${_language}:dependencies_usage_rules:start -->" >> "${_agent_file}"
      cat "${INSTALL_DIR}/${_language}/DEPENDENCIES_USAGE_RULES.md" >> "${_agent_file}"
      echo -e "<!-- ai_agents:${_language}:dependencies_usage_rules:end -->" >> "${_agent_file}"
  fi

  if [ -n "${_language}" ] && [ -f "${INSTALL_DIR}/${_language}/MCP_SERVERS.md" ]; then
      echo -e "\n<!-- ai_agents:${_language}:mcp_servers:start -->" >> "${_agent_file}"
      cat "${INSTALL_DIR}/${_language}/MCP_SERVERS.md" >> "${_agent_file}"
      echo -e "<!-- ai_agents:${_language}:mcp_servers:end -->" >> "${_agent_file}"
  fi

  echo -e "\n<!-- usage-rules-end -->" >> "${_agent_file}"

  # When reading the AGENTS.md file the AI agent will treat anything that starts by `@` as filename to include.
  # We want that references to files like `@./ARCHITECTURE.md` become `ARCHITECTURE documentation`.
  sed -i 's|@./||g; s/\.md\b/ documentation/g' "${_agent_file}"
}

Copy_All() {
  local _language="${1}"
  local _framework="${2}"

  cp "${INSTALL_DIR}/AGENTS.md" .
  cp "${INSTALL_DIR}/DEVELOPMENT_WORKFLOW.md" .
  cp "${INSTALL_DIR}/PLANNING.md" .
  cp "${INSTALL_DIR}/INTENT_SPECIFICATION.md" .
  cp "${INSTALL_DIR}/INTENT_EXAMPLE.md" .

  if [ -n "$_language" ]; then
      if [ -f "${INSTALL_DIR}/${_language}/MCP_SERVERS.md" ]; then cp "${INSTALL_DIR}/${_language}/MCP_SERVERS.md" .; fi
      if [ -f "${INSTALL_DIR}/${_language}/CODE_GUIDELINES.md" ]; then cp "${INSTALL_DIR}/${_language}/CODE_GUIDELINES.md" .; fi
      if [ -f "${INSTALL_DIR}/${_language}/DEPENDENCIES_USAGE_RULES.md" ]; then cp "${INSTALL_DIR}/${_language}/DEPENDENCIES_USAGE_RULES.md" .; fi
  fi

  if [ -n "$_framework" ]; then
      _framework_upper=$(echo "${_framework}" | tr '[:lower:]' '[:upper:]')
      _dev_file="${INSTALL_DIR}/${_language}/${_framework}/${_framework_upper}_DEVELOPMENT.md"
      if [ -f "${_dev_file}" ]; then cp "${_dev_file}" PHOENIX_DEVELOPMENT.md; fi
      if [ -f "${INSTALL_DIR}/${_language}/${_framework}/AUTHENTICATION.md" ]; then cp "${INSTALL_DIR}/${_language}/${_framework}/AUTHENTICATION.md" .; fi
      if [ -f "${INSTALL_DIR}/${_language}/${_framework}/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md" ]; then cp "${INSTALL_DIR}/${_language}/${_framework}/DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md" ARCHITECTURE.md; fi
  fi
}

Main() {

  local INSTALL_DIR="${AI_INTENT_DRIVEN_DEVELOPMENT_INSTALL_DIR:-~/.local/share/ai-coding-agents}"
  local AGENT_FILE="${AI_CODING_AGENTS_FILE:-AGENTS.md}"
  local command=""
  local agent_file=""
  local language=""
  local framework=""

  if [ $# -eq 0 ]; then
    Help
    exit 0
  fi

  command="$1"
  shift

  for arg in "$@"; do
    if [ -z "${language}" ] && [ -d "${INSTALL_DIR}/${arg}" ]; then
      language="$arg"
    elif [ -n "${language}" ] && [ -z "${framework}" ] && [ -d "${INSTALL_DIR}/${language}/${arg}" ]; then
      framework="$arg"
    elif [ -f "${arg}" ]; then
      agent_file="$arg"
    fi
  done

  if [ -z "${agent_file}" ]; then
    agent_file="${AGENT_FILE}"
  fi

  case "${command}" in

    from-scratch )
      Abort_If_Dirty_Git
      From_Scratch "${agent_file}" "${language}" "${framework}"
      exit $?
    ;;

    add )
      Abort_If_Dirty_Git
      Add_All "${agent_file}" "${language}" "${framework}"
      exit $?
    ;;

    copy )
      Abort_If_Dirty_Git
      Copy_All "${language}" "${framework}"
      exit $?
    ;;

    help )
      Help
      exit 0
    ;;

    * )
      echo ""
      echo "UNKNOWN COMMAND: ${command}"
      Help
      exit 1
    ;;

  esac
}

Main "${@}"
