if [ -f /etc/bashrc ]; then . /etc/bashrc; fi
export INPUTRC=~/.inputrc
# if this is a terminal
if [ -t 0 ]; then
  # allow C-s to search command history forward
  stty stop undef
  # allow C-w to be rebound in .inputrc
  stty werase undef
fi

umask 022
shopt -s checkwinsize
shopt -s histappend
shopt -s globstar
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000000
HISTFILESIZE=1000000
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
complete -cf sudo
complete -cf which
complete -W "$(echo `cat ~/.ssh/known_hosts 2> /dev/null | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
if [ -f ~/git-completion.bash ]; then
  source ~/git-completion.bash
fi

# terminal colors
N="\[\033[0m\]"    # unsets color to term's fg color
# regular colors
K="\[\033[0;30m\]" # black
R="\[\033[0;31m\]" # red
G="\[\033[0;32m\]" # green
Y="\[\033[0;33m\]" # yellow
B="\[\033[0;34m\]" # blue
M="\[\033[0;35m\]" # magenta
C="\[\033[0;36m\]" # cyan
W="\[\033[0;37m\]" # white
# emphasized colors
MK="\[\033[1;30m\]"
MR="\[\033[1;31m\]"
MG="\[\033[1;32m\]"
MY="\[\033[1;33m\]"
MB="\[\033[1;34m\]"
MM="\[\033[1;35m\]"
MC="\[\033[1;36m\]"
MW="\[\033[1;37m\]"
# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

# prompts
PROMPT_COLOR=$Y
if [ ${UID} -eq 0 ]; then PROMPT_COLOR=$R; fi # red for root
export PROMPT_COMMAND='history -a; if [ $? -ne 0 ]; then CURSOR_PROMPT=`echo -e "\033[0;31m>\033[0m"`; else CURSOR_PROMPT=">"; fi;'
export PS1="$W\t$N $W"'$(__git_ps1 "(%s) ")'"$N$PROMPT_COLOR\u@\H$N:$C\w$N\n"'$CURSOR_PROMPT '
export IGNOREEOF=10
export GREP_OPTIONS='--color=auto'
export PAGER=`which less`
export EDITOR=`which vim`
export GIT_EDITOR=$EDITOR
export GIT_CEILING_DIRECTORIES=`echo $HOME | sed 's#/[^/]*$##'`

(ls --color=tty &> /dev/null)
if [ $? -eq 0 ]; then
  export LS_COLOR='--color=tty' # GNU
  # set LS_COLORS
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  fi
else export LS_COLOR='-G'; export LSCOLORS='cxfxgxdxbxegedabagacad'; fi # BSD
alias ls='ls -hF $LS_COLOR'
alias ll='ls -lhF $LS_COLOR'
alias la='ls -lahF $LS_COLOR'
alias l='ls -ahF $LS_COLOR'
alias rcopy='rsync -az --stats --partial --progress'
alias rbackup='rsync -az --stats --partial --progress --delete --itemize-changes'
alias g='git'
alias tat='tmux attach'

google() { links http://google.com/search?q=$(echo "$@" | sed s/\ /+/g); }
bz2() { tar cvpjf "$1".tar.bz2 "$1"; }
gz() { tar cvpzf "$1".tar.gz "$1"; }
exto() {
  if [ -f "$2" ]; then
    if [ -f "$1" ]; then
      echo "'$1' destination path should be a directory or not yet exist"
    else
      mkdir -vp "$1"
      case "$2" in
        *.tar.bz2) tar xvjf "$2" -C "$1";;
        *.tar.gz)  tar xvzf "$2" -C "$1";;
        *.tar)     tar xvf  "$2" -C "$1";;
        *.tbz2)    tar xvjf "$2" -C "$1";;
        *.tgz)     tar xvzf "$2" -C "$1";;
        *)         echo "exto does not support '$2'";;
      esac
    fi
  else echo "second arg '$2' is not a valid file"
  fi
}
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1";;
      *.tar.gz)  tar xvzf "$1";;
      *.bz2)     bunzip2 "$1";;
      *.rar)     unrar x "$1";;
      *.gz)      gunzip "$1";;
      *.tar)     tar xvf "$1";;
      *.tbz2)    tar xvjf "$1";;
      *.tgz)     tar xvzf "$1";;
      *.zip)     unzip "$1";;
      *.Z)       uncompress "$1";;
      *.7z)      7z x "$1";;
      *)         echo "extract does not support '$1'";;
    esac
  else echo "'$1' is not a valid file"
  fi
}

findn() { FNAME="$1"; shift; find-vcs . -name "$FNAME" -print "$@"; }
findwn() { FNAME="$1"; shift; find-vcs . -wholename "$FNAME" -print "$@"; }
field() { prog='{ print $'"$1"' }'; awk "$prog"; }
git-files() {
  git $2 $3 --name-status --pretty=oneline |
  if [ "$1" -eq 0 ]; then cat; else sed 1d; fi | grep -E -v '^D' | field 2 |
    uniq
}
gdf() { git-files 0 diff $1; }
gsh() { git-files 1 show $1; }
alias vimo='vim -O'
vsh() { vimo `gsh $1`; }
vdf() { vimo `gdf $1`; }
vgrep() { vimo `grep-files "$@"`; }
vfind() { vimo `findn "$@"`; }

summ() { awk '{for (i = 1; i <= NF; ++i) total+=$i;} END{print total}'; }
alias lcr="find . -type f -exec wc -l {} \; | summ"

racki() { racket -ie '(enter! "'$1'")'; }
alias racket-tags="ctags --langmap=scheme:.rkt -R ."

pretty-json() { cat $1 | python -mjson.tool | colout -t json | less -RXF; }

PACKDIR='~/config/pack'
PACKMANAGE="$PACKDIR/manage.py"
alias plist="cat $PACKDIR/PACKAGES"
alias pinstall="sudo $PACKMANAGE -i"
alias premove="sudo $PACKMANAGE -r"
alias pfind='apt-cache search'
alias pupdate='sudo apt-get update && sudo apt-file update -N'
alias pupgrade='sudo apt-get upgrade'
alias pfile='apt-file find'
alias pfilesof='dpkg -L'
alias ppstree='pstree -p | grep package-data-do'
pshow() { apt-cache show "$@"; apt-cache policy "$@"; }
