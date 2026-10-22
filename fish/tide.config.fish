# User-owned Tide configuration. Keep generated plugin code separate from these
# values so `fisher update` can safely refresh Tide.
set -g tide_left_prompt_items pwd git newline character
set -g tide_right_prompt_items status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig

set -g tide_left_prompt_frame_enabled false
set -g tide_right_prompt_frame_enabled false
set -g tide_left_prompt_prefix ''
set -g tide_left_prompt_separator_diff_color ' '
set -g tide_left_prompt_separator_same_color ' '
set -g tide_left_prompt_suffix ' '
set -g tide_right_prompt_prefix ' '
set -g tide_right_prompt_separator_diff_color ' '
set -g tide_right_prompt_separator_same_color ' '
set -g tide_right_prompt_suffix ''

set -g tide_prompt_add_newline_before true
set -g tide_prompt_color_frame_and_connection brblack
set -g tide_prompt_color_separator_same_color brblack
set -g tide_prompt_icon_connection ·
set -g tide_prompt_min_cols 34
set -g tide_prompt_pad_items false
set -g tide_prompt_transient_enabled true

set -g tide_character_color brgreen
set -g tide_character_color_failure brred
set -g tide_character_icon '>'
set -g tide_character_vi_icon_default '<'
set -g tide_character_vi_icon_insert '>'
set -g tide_character_vi_icon_replace ▶
set -g tide_character_vi_icon_visual '<'

set -g tide_git_color_branch brgreen
set -g tide_git_color_conflicted brred
set -g tide_git_color_dirty bryellow
set -g tide_git_color_operation brred
set -g tide_git_color_staged bryellow
set -g tide_git_color_stash brgreen
set -g tide_git_color_untracked brblue
set -g tide_git_color_upstream brgreen
set -g tide_git_truncation_length 24
set -g tide_git_truncation_strategy ''

set -g tide_pwd_color_anchors cyan
set -g tide_pwd_color_dirs cyan
set -g tide_pwd_color_truncated_dirs magenta
set -g tide_cmd_duration_color brblack
set -g tide_cmd_duration_threshold 3000
