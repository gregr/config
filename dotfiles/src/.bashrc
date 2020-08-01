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
export PS1="$N\t$N $MR"'$(__git_ps1 "(%s) ")'"$N$PROMPT_COLOR\u@\H$N:$C\w$N\n"'$CURSOR_PROMPT '
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
export LS_COLORS='rs=0:di=36:ln=32:mh=00:pi=33:so=33:do=33:bd=00:cd=00:or=05;36:mi=04;93:su=31:sg=31:ca=00:tw=36:ow=36:st=36:ex=031:*.tar=00:*.tgz=00:*.arc=00:*.arj=00:*.taz=00:*.lha=00:*.lz4=00:*.lzh=00:*.lzma=00:*.tlz=00:*.txz=00:*.tzo=00:*.t7z=00:*.zip=00:*.z=00:*.dz=00:*.gz=00:*.lrz=00:*.lz=00:*.lzo=00:*.xz=00:*.zst=00:*.tzst=00:*.bz2=00:*.bz=00:*.tbz=00:*.tbz2=00:*.tz=00:*.deb=00:*.rpm=00:*.jar=00:*.war=00:*.ear=00:*.sar=00:*.rar=00:*.alz=00:*.ace=00:*.zoo=00:*.cpio=00:*.7z=00:*.rz=00:*.cab=00:*.wim=00:*.swm=00:*.dwm=00:*.esd=00:*.jpg=00:*.jpeg=00:*.mjpg=00:*.mjpeg=00:*.gif=00:*.bmp=00:*.pbm=00:*.pgm=00:*.ppm=00:*.tga=00:*.xbm=00:*.xpm=00:*.tif=00:*.tiff=00:*.png=00:*.svg=00:*.svgz=00:*.mng=00:*.pcx=00:*.mov=00:*.mpg=00:*.mpeg=00:*.m2v=00:*.mkv=00:*.webm=00:*.ogm=00:*.mp4=00:*.m4v=00:*.mp4v=00:*.vob=00:*.qt=00:*.nuv=00:*.wmv=00:*.asf=00:*.rm=00:*.rmvb=00:*.flc=00:*.avi=00:*.fli=00:*.flv=00:*.gl=00:*.dl=00:*.xcf=00:*.xwd=00:*.yuv=00:*.cgm=00:*.emf=00:*.ogv=00:*.ogx=00:*.aac=00:*.au=00:*.flac=00:*.m4a=00:*.mid=00:*.midi=00:*.mka=00:*.mp3=00:*.mpc=00:*.ogg=00:*.ra=00:*.wav=00:*.oga=00:*.opus=00:*.spx=00:*.xspf=00:'
alias mv='mv -vn'
alias cp='cp -vn'
alias ls='ls -hF $LS_COLOR'
alias ll='ls -lhF $LS_COLOR'
alias la='ls -lahF $LS_COLOR'
alias l='ls -ahF $LS_COLOR'
alias tdu='tree -DFh --du --dirsfirst'
alias t='tree -DFhs --dirsfirst'
alias t1='tree -DFhs --dirsfirst -L 1'
alias t2='tree -DFhs --dirsfirst -L 2'
alias t3='tree -DFhs --dirsfirst -L 3'
alias tadu='tree -aDFh --du --dirsfirst'
alias ta='tree -aDFhs --dirsfirst'
alias ta1='tree -aDFhs --dirsfirst -L 1'
alias ta2='tree -aDFhs --dirsfirst -L 2'
alias ta3='tree -aDFhs --dirsfirst -L 3'
alias tgdu='tree -aDFh --du --dirsfirst -I .git'
alias tg='tree -aDFhs --dirsfirst -I .git'
alias tg1='tree -aDFhs --dirsfirst -I .git -L 1'
alias tg2='tree -aDFhs --dirsfirst -I .git -L 2'
alias tg3='tree -aDFhs --dirsfirst -I .git -L 3'
alias rcopy='rsync -az --stats --partial --progress'
alias rbackup='rsync -az --stats --partial --progress --delete --itemize-changes'
alias g='git'
alias tat='tmux attach'
alias mirror='wget -mpEk --no-parent'  # m: mirror; p: images, css, etc.; E: extensions; k: fix links

mountv() { { echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4=""; {print}'; } | column -t; }
google() { links http://google.com/search?q=$(echo "$@" | sed s/\ /+/g); }
download() { wget -rl "$1" "$2"; }
bz2dir() { dir=${1%/}; tar cvpjf "$dir".tar.bz2 "$dir"; }
gzdir() { dir=${1%/}; tar cvpzf "$dir".tar.gz "$dir"; }
tardir() { dir=${1%/}; tar cvpf "$dir".tar "$dir"; }
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
tunnel() { ssh -L "$1:127.0.0.1:$1" -C -N "${@:2}"; }
tunnelvnc() { tunnel 5901 "$@"; }

findn() { local FNAME="$1"; shift; find-vcs . -name "$FNAME" -print "$@"; }
findwn() { local FNAME="$1"; shift; find-vcs . -wholename "$FNAME" -print "$@"; }
field() { awk '{ print $'"$1"' }'; }
line() { head -n $(($1 + 1)) | tail -1; }
ltrim() { sed -e 's/^[[:space:]]*//'; }
rtrim() { sed -e 's/[[:space:]]*$//'; }
lrtrim() { ltrim | rtrim; }
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
vsession() { vim -S "$HOME/.vim/sessions/$1.vim"; }

summ() { awk '{for (i = 1; i <= NF; ++i) total+=$i;} END{print total}'; }
alias lcr="find . -type f -exec wc -l {} \; | summ"

racki() { racket -ie '(enter! "'$1'")'; }
alias racket-tags="ctags --langmap=scheme:.rkt -R ."

lesscolor() { less -RXF; }
pretty-json() { python -mjson.tool | colout -t json | lesscolor; }

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
