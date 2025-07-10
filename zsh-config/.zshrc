# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Any code that may require console input (e.g., password prompts) must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme: Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Zsh plugins
# - git: Git aliases and completion
# - z: Jump to frequently used directories
# - docker: Docker command shortcuts
# - zsh-autosuggestions: Suggest commands based on history
# - zsh-syntax-highlighting: Highlight valid/invalid commands
plugins=(
  git
  z
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh framework
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# History entries include date (format: yyyy-mm-dd)
HIST_STAMPS="yyyy-mm-dd"

# Hyphen-insensitive completion: treats `-` and `_` as equivalent
HYPHEN_INSENSITIVE="true"
