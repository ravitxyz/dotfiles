#!/bin/bash

# Script to automatically discover and configure git worktrees for tmux-sessionizer

# Base projects directory
PROJECTS_DIR="$HOME/projects"

# Cache file to track last update
CACHE_FILE="$HOME/.cache/tms-worktrees-cache"
mkdir -p "$(dirname "$CACHE_FILE")"

# Function to get current worktree list
get_current_worktrees() {
    find "$PROJECTS_DIR" -path "*/worktrees/*" -name ".git" -type f 2>/dev/null | \
        grep -F "gitdir:" | \
        xargs -I {} dirname {} | \
        sort
}

# Check if update is needed
CURRENT_WORKTREES=$(get_current_worktrees)
CURRENT_HASH=$(echo "$CURRENT_WORKTREES" | shasum -a 256 | cut -d' ' -f1)

if [ -f "$CACHE_FILE" ] && [ "$(cat "$CACHE_FILE")" = "$CURRENT_HASH" ]; then
    echo "Worktrees unchanged, skipping update"
    exit 0
fi

echo "Updating tms configuration with current worktrees..."

# Set basic search paths (just the main projects directory)
tms config --paths "$PROJECTS_DIR" 2>/dev/null

# Find all worktrees and bookmark them individually
WORKTREE_COUNT=0

# Find worktrees in all project directories
for project_dir in "$PROJECTS_DIR"/*; do
    if [ -d "$project_dir" ]; then
        # Check if this project has worktrees
        if [ -d "$project_dir/worktrees" ]; then
            # Find all worktrees in this project's worktrees directory
            for worktree_dir in "$project_dir/worktrees"/*; do
                if [ -d "$worktree_dir" ] && [ -f "$worktree_dir/.git" ] && grep -q "gitdir:" "$worktree_dir/.git" 2>/dev/null; then
                    # Get just the worktree name (e.g., EDT-726)
                    worktree_name=$(basename "$worktree_dir")
                    echo "Bookmarking worktree: $worktree_name at $worktree_dir"
                    tms bookmark "$worktree_dir" 2>/dev/null || true
                    WORKTREE_COUNT=$((WORKTREE_COUNT + 1))
                fi
            done
        fi
    fi
done

# Update cache
echo "$CURRENT_HASH" > "$CACHE_FILE"

echo "Bookmarked $WORKTREE_COUNT worktrees"
echo "Use Ctrl-f Ctrl-o to see all projects and bookmarked worktrees"