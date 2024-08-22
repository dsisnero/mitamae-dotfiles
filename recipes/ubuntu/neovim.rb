github_binary "nvim" do
  repository "neovim/neovim"
  version "v0.10.1"
  archive "nvim.appimage"
end

git "nvim_config" do
  repository "https://github.com/dsisnero/astronvim_config.git"
  destination "#{ENV["HOME"]}/.config/nvim"
  user node[:user]
  revision "HEAD"
end
