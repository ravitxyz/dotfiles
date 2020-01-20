# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/ravit/.oh-my-zsh
export PROJECT_HOME=/home/ravit/projects
export CURRENT_PROJECT=

# ZSH_THEME="candy"
# ZSH_THEME="amuse"
# ZSH_THEME="gallois"
ZSH_THEME="cloud"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"
 ENABLE_CORRECTION="true"
 COMPLETION_WAITING_DOTS="true"
 HIST_STAMPS="mm/dd/yyyy"
source $ZSH/oh-my-zsh.sh

unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

#lazy stuff
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ls='ls -lah'
alias sz='source ~/.zshrc'

alias cdoc='/mnt/c/Users/ravit/Google\ Drive/Master/projects'

# projects
alias project="cd ~/projects/$CURRENT_PROJECT"
alias gov="cd $VIRTUAL_ENV/bin"
alias journal="cd ~/projects/goals"

# git stuff
alias startover='git status | grep "modified" | awk "{print \$2}" | xargs -I{} git checkout -- {}'

# tmux stuff
alias tmux="TERM=screen-256color-bce tmux"
alias tm="tmux new-session"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"

# django stuff
alias rabbit="invoke-rc.d rabbitmq-server"
alias dtest="project && python manage.py test"
alias celeryworker="celery -A $CURRENT_PROJECT worker -l info"
alias runserver="cd ~/projects/$CURRENT_PROJECT && python manage.py runserver"
alias collect="cd ~/projects/$CURRENT_PROJECT && python manage.py collectstatic"

# edit dotfiles
alias dotfiles="cd ~/dotfiles && git status"
alias editzshrc="vim ~/dotfiles/.zshrc"
alias editvimrc="vim ~/dotfiles/.vimrc"
alias edittmux="vim ~/dotfiles/tmux.config"
alias ohmyzsh="vm ~/.oh-my-zsh"

# heroku stuff
alias hl="heroku login"

# vps stuff
alias finnegan="ssh root@$FINNEGAN_VPS"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ravit.s/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ravit.s/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ravit.s/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ravit.s/google-cloud-sdk/completion.zsh.inc'; fi



# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# path to anconda 3 installation
export PATH="/home/ravit/anaconda3/bin:$PATH"
