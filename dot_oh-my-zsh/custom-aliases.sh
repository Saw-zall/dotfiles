alias vi="nvim"
alias vim="nvim"
alias zshreload="source ~/.zshrc"
alias updateapt="sudo apt update && sudo apt upgrade"
alias aptupdate="updateapt"
alias pdfreader="zathura"
alias start-ollama-server="ollama serve > /dev/null 2>&1 &"
alias gitversion="dotnet-gitversion"
alias runtipi="sudo service docker start ; cd ~/Installed_Apps/runtipi && sudo ./runtipi-cli start"
alias vimdiff='nvim -d'
alias reload-wallpaper='systemctl --user start wallpaper-rotate.service'
alias auditaur='grep -RInE "curl|wget|requests|urllib|httpx|socket|subprocess|os\.system|Popen|exec|eval|compile|pty|fork|systemctl|sudo|chmod 777|rm -rf|base64|b64decode|marshal|pickle|ctypes|dlopen|LD_PRELOAD"'

# configs
alias zshconfig="chezmoi edit ~/.zshrc"
alias aliasconfig="chezmoi edit ~/.oh-my-zsh/custom-aliases.sh"
alias hyprconfig="chezmoi edit ~/.config/hypr/hyprland.conf"
alias waybarconfig="chezmoi edit ~/.config/waybar/config"
