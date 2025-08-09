alias vi="nvim"
alias vim="nvim"
alias bat="batcat"
alias zshconfig="lvim ~/.zshrc"
alias aliasconfig="lvim ~/.oh-my-zsh/custom-aliases.sh"
alias zshreload="source ~/.zshrc"
alias updateapt="sudo apt update && sudo apt upgrade"
alias aptupdate="sudo apt update && sudo apt upgrade"
alias pdfreader="zathura"
alias start-ollama-server="ollama serve > /dev/null 2>&1 &"
alias output="batcat -l md"
alias output-fr="fabric -p translate_fr | batcat -l md"
alias pt="yt --transcript --lang en $1"
alias gitversion="dotnet-gitversion"
alias runtipi="sudo service docker start ; cd ~/Installed_Apps/runtipi && sudo ./runtipi-cli start"
alias vimdiff='nvim -d'
function search-fabric-pattern() { fabric -l | grep $1 | column }
function describe-fabric-pattern() { batcat "$HOME/.config/fabric/patterns/$1/system.md" -l md ; }
# function describe-fabric-pattern() { cat "$HOME/.config/fabric/patterns/$1/system.md" | fabric -p summarize | batcat -l md ; }
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Open cutter detached and close standard output and error
# alias cutter="cutter > /dev/null 2>&1 &"
