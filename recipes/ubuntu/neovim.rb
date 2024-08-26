# github_binary "nvim" do
#   repository "neovim/neovim"
#   version "v0.10.1"
#   archive "nvim.appimage"
# end

# assume bob is unstalled by rust - needs to use rust recipe first

cargo_install "bob-nvim" do
  binname "bob"
end

neovim_init = <<-EOS
  export PATH=#{ENV["HOME"]}/.local/share/bob/nvim-bin:$PATH
EOS

neovim_init.split("\n").each do |line|
  execute "append #{line} to bashrc" do
    command "echo '#{line}' >> #{ENV["HOME"]}/.bashrc"
    not_if "grep 'bob/nvim-bin' #{ENV["HOME"]}/.bashrc"
  end
end

git "nvim_config" do
  repository "https://github.com/dsisnero/astronvim_config.git"
  destination "#{ENV["HOME"]}/.config/nvim"
  user node[:user]
  revision "HEAD"
end
