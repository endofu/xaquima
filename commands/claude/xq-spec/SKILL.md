---
name: xq-spec
description: Search and display relevant architecture documentation from .agent/specs/. Use when you need to understand how a component works.
disable-model-invocation: true
argument-hint: "<search-term>"
---
Search the project's living architecture documentation for: **$ARGUMENTS**

## Context
- Available spec files: !`ls -la .agent/specs/ 2>/dev/null || echo "No specs directory"`

## Instructions
1. Search all files in `.agent/specs/` for content matching "$ARGUMENTS".
2. For each matching file:
   - Show the filename and a brief summary of what it documents
   - Show the relevant matching sections
   - Show any cross-references to other spec files
3. If no matches found, list all available spec files with their first heading as a summary.
