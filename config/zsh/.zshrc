source "$HOME/.bash_profile"

function load_sqrx_helper() {
  if [ -f "$HOME/.sqrx_helper" ]; then
    source "$HOME/.sqrx_helper"
    echo "Started sqrx alias helper ✅"
  else
    echo "Could not find sqrx helper 🚫"
  fi
}

alias lsh=load_sqrx_helper

# Google Cloud SDK PATH and completion
if [ -f "$HOME/dev/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/dev/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/dev/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/dev/google-cloud-sdk/completion.zsh.inc"
fi

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun & Java PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# Setup for Gemini CLI
export GOOGLE_CLOUD_PROJECT="eng-systems-ai-code-assist"

# Dotfiles helper aliases
alias dots="cd $HOME/dev/dotfiles && git status"

# Load local / private overrides (never tracked in git)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
