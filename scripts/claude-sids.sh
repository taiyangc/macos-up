#!/bin/bash

claude agents --json --all | jq -r '
  .[] | select(.kind == "background") |
  [.id, .sessionId, .state, .cwd, .name] | @tsv
'
