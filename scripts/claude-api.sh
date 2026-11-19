#!/bin/bash

claude -p \
  --resume "$SID" \
  "Resume" \
  --output-format stream-json \
  --verbose \
  --include-partial-messages \
  | tee /tmp/claude-progress.jsonl \
  | jq --unbuffered -rj '
    if .type == "stream_event" and .event.delta.type? == "text_delta" then
      .event.delta.text
    elif .type == "assistant" then
      .message.content[]? |
      select(.type == "tool_use") |
      "\n\n⏺ \(.name): \(.input.command // .input.file_path // .input.description // .input.pattern // "" | tostring)\n"
    else
      empty
    end
  '
