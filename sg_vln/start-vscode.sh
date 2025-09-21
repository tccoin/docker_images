#!/usr/bin/env bash
set -euo pipefail

# Run user startup script in the background under the webvnc conda env if available
if [ -f /startup.sh ]; then
  if [ -f "${CONDA_DIR:-/root/conda}/etc/profile.d/conda.sh" ]; then
    bash -lc "source ${CONDA_DIR:-/root/conda}/etc/profile.d/conda.sh && conda activate webvnc && bash /startup.sh" &
  else
    bash /startup.sh &
  fi
fi

# Start VS Code Server (authenticate with password if $PASSWORD is set, else no auth)
AUTH_ARG="--auth none"
if [ -n "${PASSWORD:-}" ]; then AUTH_ARG="--auth password"; fi
exec code-server --bind-addr 0.0.0.0:${VSCODE_PORT:-8080} ${AUTH_ARG}


