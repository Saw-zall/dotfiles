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

# configs
alias zshconfig="chezmoi edit ~/.zshrc"
alias aliasconfig="chezmoi edit ~/.oh-my-zsh/custom-aliases.sh"
alias hyprconfig="chezmoi edit ~/.config/hypr/hyprland.conf"
alias waybarconfig="chezmoi edit ~/.config/waybar/config"

