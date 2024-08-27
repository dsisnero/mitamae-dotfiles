node.reverse_merge!(
  os: run_command("uname").stdout.strip.downcase,
  user: ENV["SUDO_USER"] || ENV["USER"]
)

include_recipe "helpers"

directory "#{ENV["HOME"]}/bin" do
  owner node[:user]
end

github_binary "ghq" do
  repository "motemen/ghq"
  version "v0.10.0"
  archive "ghq_#{node[:os]}_amd64.zip"
  binary_path "ghq_#{node[:os]}_amd64/ghq"
end

# github_binary "gh" do
#   repository "motemen/ghq"
#   version "v0.10.0"
#   archive "ghq_#{node[:os]}_amd64.zip"
#   binary_path "ghq_#{node[:os]}_amd64/ghq"
# end

# (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
# && sudo mkdir -p -m 755 /etc/apt/keyrings \
# && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
# && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
# && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# && sudo apt update \
# && sudo apt install gh -y

apt_repository "gh repo deb" do
  action :add
  url "https://cli.github.com/packages stable main"
  gpg_key "https://cli.github.com/packages/githubcli-archive-keyring.gpg"
end

package "gh"

github_binary "peco" do
  repository "peco/peco"
  version "v0.5.10"
  ext = ((node[:platform] == "darwin") ? "zip" : "tar.gz")
  archive "peco_#{node[:os]}_amd64.#{ext}"
  binary_path "peco_#{node[:os]}_amd64/peco"
end

github_binary "lazygit" do
  repository "jesseduffield/lazygit"
  version "v0.43.1"
  ext = ((node[:platform] == "darwin") ? "zip" : "tar.gz")
  archive "lazygit_#{version[1..-1]}_Linux_x86_64.tar.gz"
  binary_path "lazygit"
end

github_binary "rclone" do
  repository "rclone/rclone"
  version "v1.67.0"
  archive "rclone-#{version}-linux-amd64.zip"
  binary_path "rclone-#{version}-linux-amd64/rclone"
end

github_binary "gdrive" do
  repository "glotlabs/gdrive"
  version "3.9.1"
  archive "gdrive_linux-x64.tar.gz"
  binary_path "gdrive"
end

execute("rclone self-update --package deb") do
  only_if "which rclone"
end

if node[:os] == "linux"
  dotfile ".bashrc"

  execute "source .bashrc" do
    command ". #{ENV["HOME"]}/.bashrc"
  end
  ENV["PATH"] = "/home/#{node[:user]}/bin:#{ENV["PATH"]}"
end
puts "Path:/n#{ENV["PATH"]}"
include_recipe "python"
