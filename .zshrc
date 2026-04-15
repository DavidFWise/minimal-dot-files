# Enable colors
export TERM="xterm-256color"

# 1. Modern Tool Aliases (Ubuntu specific package names handled here)
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias cat='batcat'
alias fd='fdfind'

# Git shortcuts
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
# Launch GitUI instantly
alias g='gitui'
# 2. Zsh History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY # Share history across multiple terminal windows
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# 3. Initialize Modern Tools
# Initialize Starship prompt
eval "$(starship init zsh)"

# Initialize Zoxide (smarter cd)
eval "$(zoxide init zsh)"
# Initialize Atuin (Replaces standard history)
eval "$(atuin init zsh)"

# Yazi Wrapper
# Use the command 'y' to open the file manager. 
# When you quit (q), it will automatically cd your terminal into the last folder you were viewing.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# 4. Load Zsh Plugins (Syntax highlighting and auto-suggestions)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
