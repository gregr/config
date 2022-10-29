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
alias mirrorc='mirror --no-check-certificate'
alias mirror1='wget -pEk'
alias mirror1c='mirror1 --no-check-certificate'

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

split10g() { split -b 10000m "$1" "$1.split."; }

racki() { racket -ie '(enter! "'$1'")'; }
racke() { racket -l errortrace -u "$1"; }
alias racket-tags="ctags --langmap=scheme:.rkt -R ."

lesscolor() { less -RXF; }
pretty-json() { python -mjson.tool | colout -t json | lesscolor; }
