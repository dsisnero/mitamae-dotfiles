class Specinfra::Command::Pop < Specinfra::Command::Ubuntu
end
# dotfile ".config/nvim/init.lua"
dotfile ".config/git/config"
dotfile ".config/helix/config.toml"
dotfile ".config/helix/languages.toml"
dotfile ".config/solargraph/config.yml"
dotfile ".config/git/config"
dotfile ".config/wezterm/wezterm.lua"
dotfile ".config/peco/config.json"
dotfile ".gdbinit"
dotfile ".pryrc"
dotfile ".railsrc"
dotfile ".config/tmux/tmux.conf"
dotfile ".config/tmux/tmux.conf.local" => ".tmux.conf.linux"
include_recipe "neovim"
include_recipe "systemd"
# include_recipe "zsh"

include_recipe "ruby"
include_recipe "docker"
include_recipe "rust"

package "fzf"
package "git"
package "htop"
package "tmux"
package "xclip"

directory "#{ENV["HOME"]}/.config/systemd/user/default.target.wants" do
  owner node[:user]
  group node[:user]
  mode "755"
end

include_recipe "ssh-agent"
# include_recipe "gpg-agent"
# include_recipe "ddns-update"
# include_recipe "xremap"

# For dual boot Windows
execute "timedatectl set-local-rtc true" do
  only_if "timedatectl status | grep 'RTC in local TZ: no'"
end

# Wireguard
# remote_file "#{ENV["HOME"]}/.config/autostart/nm-applet.desktop" do
#   owner node[:user]
#   group node[:user]
# end
