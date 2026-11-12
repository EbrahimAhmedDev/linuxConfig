# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# User specific environment & PATH
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# opencode
PATH="$HOME/.opencode/bin:$PATH"
export PATH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                  # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# Which plugins would you like to load?
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- Docker ----------
alias dockerstart='sudo systemctl start docker && echo "⚡ Docker Started!"'
alias dockerstop='sudo systemctl stop docker && echo "🛑 Docker Stopped!"'
alias dockerrestart='sudo systemctl restart docker && echo "🔄 Docker Restarted!"'
alias dockerstatus='systemctl status docker'

# ---------- System ----------
alias update='sudo dnf update -y'
alias cls='clear'

# ---------- Eza (modern ls replacement) ----------
alias ls='eza --color=auto --icons=auto'
alias ll='eza -l --color=auto --icons=auto'
alias la='eza -lah --color=auto --icons=auto'
alias lt='eza -T --color=auto --icons=auto'


# ---------- Custom Zsh Plugins Auto-Loader ----------
if [ -d "$HOME/.config/zsh/plugins" ]; then
    for plugin in "$HOME/.config/zsh/plugins"/*.plugin.zsh(N); do
        source "$plugin"
    done
fi

# ---------- FZF Styling & Customization ----------
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border=rounded
  --prompt='󰜴 '
  --pointer='▶'
  --marker='✓'
  --color=spinner:#f38ba8,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,prompt:#cba6f7,hl+:#f38ba8
"

# ---------- fzf (fuzzy finder + completion for zsh) ----------
if [[ -o interactive ]]; then
  source <(fzf --zsh)
fi

# ---------- Starship prompt (keep this last) ----------
eval "$(starship init zsh)"


# Added by Antigravity CLI installer
export PATH="/home/ebrahim/.local/bin:$PATH"
