---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <file-or-pattern>
disable-model-invocation: true
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Read `rules.md` in this skill's folder
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Read the pinned copy `rules.md` in this skill's folder. It contains all the rules and the output format.
(Vendored copy: the upstream skill fetched
`https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md` on every run;
this copy reads the local file so it works without network access.)

## Usage

When a user provides a file or pattern argument:
1. Read `rules.md` in this skill's folder
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
