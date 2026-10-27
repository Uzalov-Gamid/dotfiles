#!/bin/bash
# Prints the git-branch pill of the tmux status bar for the folder in $1
# (nothing outside a repository). Called from theme.conf.
branch=$(git -C "$1" branch --show-current 2>/dev/null)
[ -n "$branch" ] || branch=$(git -C "$1" rev-parse --short HEAD 2>/dev/null)
[ -n "$branch" ] || exit 0
printf ' #[fg=#2a1f1b bg=default]#[fg=#b5b07a bg=#2a1f1b] %s#[fg=#2a1f1b bg=default]' "$branch"
