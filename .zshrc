# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,exports,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load zsh completions
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# Completion; Use cache idf updated within 24th
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else 
  compinit -C;
fi;

# Disable zsh bundled funciton mtools command mcd
## Which cause a conflict.
compdef -d mcd

# オプション
## 日本語ファイル名を表示可能にする
setopt print_eight_bit 

## ディレクトリ名だけでcdする  
setopt print_eight_bit 