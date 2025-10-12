#!/usr/bin/env bash
set -euo pipefail
LOG_FILE=${1:-}
PATTERN=${2:-_notebooks/.*\.ipynb}

if [[ -z "${LOG_FILE}" ]]; then
  echo "Usage: $0 <log_file> [pattern]"
  exit 1
fi

serverReady=false
regenerate=false

# Tail the log and parse events to trigger per-file conversion
# shellcheck disable=SC2034
exec 3< <(tail -n +1 -f "$LOG_FILE")
while IFS= read -r line <&3; do
  if [[ "$line" =~ Server\ address: ]]; then
    serverReady=true
  fi
  if $serverReady && [[ "$line" =~ ^[[:space:]]*Regenerating: ]]; then
    regenerate=true
  fi

  if $regenerate; then
    # Blank line ends the regenerate block
    if [[ "$line" =~ ^[[:space:]]*$ ]]; then
      regenerate=false
      continue
    fi
    echo "$line"

    if [[ "$line" =~ ${PATTERN} ]]; then
      # Extract first notebook path match
      nb=$(printf '%s' "$line" | sed -n 's/.*\(_notebooks\/[[:alnum:]_.\/-]*\.ipynb\).*/\1/p')
      if [[ -n "$nb" ]]; then
        nohup make convert-one ONE_FILE="$nb" >/dev/null 2>&1 &
      fi
    fi
  fi

done
